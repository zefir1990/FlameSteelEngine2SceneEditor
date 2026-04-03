import Foundation
import PresentationKit
#if os(Windows)
import WinSDK
#elseif os(macOS) || os(iOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif

/// A dedicated interactor that listens for UDP events (e.g., ButtonActions) 
/// from the WidgetsServer and processes them.
public class WxInteractor {
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
        
        // We use a detached task because recvfrom is a blocking synchronous call.
        // This prevents the blocking call from starvation of the cooperative thread pool.
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
        #if os(Windows)
        await runWindowsListener()
        #else
        await runPOSIXListener()
        #endif
    }

    #if os(Windows)
    private func runWindowsListener() async {
        var wsaData = WSADATA()
        let wsaResult = WSAStartup(0x0202, &wsaData)
        if wsaResult != 0 {
            print("WxInteractor: WSAStartup failed.")
            return
        }
        defer { WSACleanup() }

        let sock = socket(Int32(AF_INET), Int32(SOCK_DGRAM), Int32(IPPROTO_UDP.rawValue))
        if sock == INVALID_SOCKET {
            print("WxInteractor: Failed to create socket.")
            return
        }
        defer { closesocket(sock) }

        var addr = sockaddr_in()
        addr.sin_family = ADDRESS_FAMILY(AF_INET)
        addr.sin_port = UInt16(port).bigEndian

        let bindResult = withUnsafePointer(to: &addr) { addrPtr in
            addrPtr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockaddrPtr in
                bind(sock, sockaddrPtr, Int32(MemoryLayout<sockaddr_in>.size))
            }
        }

        if bindResult == SOCKET_ERROR {
            print("WxInteractor: Failed to bind socket to port \(port). Error: \(WSAGetLastError())")
            return
        }

        print("WxInteractor: Listening for events on UDP port \(port)...")

        var buffer = [Int8](repeating: 0, count: 8192)
        var clientAddr = sockaddr_in()
        var clientAddrLen = Int32(MemoryLayout<sockaddr_in>.size)

        while !Task.isCancelled {
            let bytesReceived = withUnsafeMutablePointer(to: &clientAddr) { clientAddrPtr in
                clientAddrPtr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockaddrPtr in
                    recvfrom(sock, &buffer, Int32(buffer.count), 0, sockaddrPtr, &clientAddrLen)
                }
            }

            if bytesReceived > 0 {
                let data = Data(bytes: buffer, count: Int(bytesReceived))
                if let message = String(data: data, encoding: .utf8) {
                    await processMessage(message)
                }
            } else if bytesReceived == SOCKET_ERROR {
                let error = WSAGetLastError()
                if error != WSAEINTR {
                    print("WxInteractor: recvfrom failed with error \(error)")
                }
                break
            }
        }
    }
    #else
    private func runPOSIXListener() async {
        let sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        if sock < 0 {
            print("WxInteractor: Failed to create socket.")
            return
        }
        defer { close(sock) }

        var addr = sockaddr_in()
        #if os(macOS) || os(iOS)
        addr.sin_len = __uint8_t(MemoryLayout<sockaddr_in>.size)
        #endif
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(port).bigEndian
        addr.sin_addr.s_addr = in_addr_t(0).bigEndian

        let bindResult = withUnsafePointer(to: &addr) { addrPtr in
            addrPtr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockaddrPtr in
                bind(sock, sockaddrPtr, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }

        if bindResult < 0 {
            print("WxInteractor: Failed to bind socket to port \(port).")
            return
        }

        print("WxInteractor: Listening for events on UDP port \(port)...")

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
                    print("WxInteractor: recvfrom failed with error \(errno)")
                }
                break
            }
        }
    }
    #endif

    private func processMessage(_ message: String) async {
        print("Received message: \(message)")
        guard let data = message.data(using: .utf8),
              let payload = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let command = payload["command"] as? String,
              let args = payload["args"] as? [String: Any] else {
            return
        }

        if command == "ButtonAction", let uuidString = args["id"] as? String, let uuid = Foundation.UUID(uuidString: uuidString) {
            print("visit ButtonAction with UUID: \(uuidString)")
            
            await MainActor.run {
                if let action = buttonActions[uuid] {
                    action()
                }
            }
        }
    }
}
