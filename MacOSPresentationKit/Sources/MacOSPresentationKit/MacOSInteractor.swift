import Foundation
import PresentationKit
import Darwin

/// A dedicated interactor that listens for UDP events (e.g., ButtonActions) 
/// from the WidgetsServer on macOS.
public class MacOSInteractor {
    private let port: Int
    private var listenerTask: Task<Void, Never>?
    
    @MainActor
    private var buttonActions: [Foundation.UUID: () -> Void] = [:]

    public init(port: Int = 50052) {
        self.port = port
    }

    /// Registers a closure to be executed when a button with the given ID is clicked.
    @MainActor
    public func registerAction(id: Foundation.UUID, action: @escaping () -> Void) {
        buttonActions[id] = action
    }

    /// Starts the UDP listener in a background task.
    public func start() {
        guard listenerTask == nil else { return }
        
        listenerTask = Task.detached { [weak self] in
            await self?.runListener()
        }
    }

    /// Stops the UDP listener.
    public func stop() {
        listenerTask?.cancel()
        listenerTask = nil
    }

    private func runListener() async {
        let sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        if sock < 0 {
            print("MacOSInteractor: Failed to create socket.")
            return
        }
        defer { close(sock) }

        var addr = sockaddr_in()
        addr.sin_len = __uint8_t(MemoryLayout<sockaddr_in>.size)
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(port).bigEndian
        addr.sin_addr.s_addr = in_addr_t(0).bigEndian

        let bindResult = withUnsafePointer(to: &addr) { addrPtr in
            addrPtr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockaddrPtr in
                bind(sock, sockaddrPtr, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }

        if bindResult < 0 {
            print("MacOSInteractor: Failed to bind socket to port \(port).")
            return
        }

        print("MacOSInteractor: Listening for events on UDP port \(port)...")

        var buffer = [UInt8](repeating: 0, count: 8192)
        var clientAddr = sockaddr_in()
        var clientAddrLen = socklen_t(MemoryLayout<sockaddr_in>.size)

        while !Task.isCancelled {
            let bytesReceived = withUnsafeMutablePointer(to: &clientAddr) { clientAddrPtr in
                clientAddrPtr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockaddrPtr in
                    recvfrom(sock, &buffer, buffer.count, 0, sockaddrPtr, &clientAddrLen)
                }
            }

            if bytesReceived > 0 {
                let data = Data(bytes: buffer, count: Int(bytesReceived))
                if let message = String(data: data, encoding: .utf8) {
                    await processMessage(message)
                }
            } else if bytesReceived < 0 {
                if errno != EINTR {
                    print("MacOSInteractor: recvfrom failed with error \(errno)")
                }
                break
            }
        }
    }

    private func processMessage(_ message: String) async {
        guard let data = message.data(using: .utf8),
              let payload = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let command = payload["command"] as? String,
              let args = payload["args"] as? [String: Any] else {
            return
        }

        if command == "ButtonAction", let uuidString = args["id"] as? String, let uuid = Foundation.UUID(uuidString: uuidString) {
            await MainActor.run {
                if let action = buttonActions[uuid] {
                    action()
                }
            }
        }
    }
}
