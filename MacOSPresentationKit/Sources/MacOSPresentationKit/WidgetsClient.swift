import Foundation
import Darwin

/// A lightweight UDP client designed to communicate with the WidgetsServer on macOS.
public struct WidgetsClient {
    private let host: String
    private let port: Int

    public init(host: String = "127.0.0.1", port: Int = 50051) {
        self.host = host
        self.port = port
    }

    /// Sends a JSON command to the WidgetsServer.
    public func send(command: String, args: [String: Any]) {
        let payload: [String: Any] = [
            "command": command,
            "args": args
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("WidgetsClient: Failed to serialize command payload.")
            return
        }

        sendUDP(jsonString)
    }

    public func shutdown() {
        print("WidgetsClient: UDP session finalized.")
    }

    private func sendUDP(_ message: String) {
        let sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        if sock < 0 {
            print("WidgetsClient: Failed to create socket.")
            return
        }
        defer { close(sock) }

        var addr = sockaddr_in()
        addr.sin_len = __uint8_t(MemoryLayout<sockaddr_in>.size)
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(port).bigEndian
        inet_pton(AF_INET, host, &addr.sin_addr)

        message.withCString { cString in
            withUnsafePointer(to: &addr) { addrPtr in
                addrPtr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockaddrPtr in
                    _ = sendto(sock, cString, Int(message.utf8.count), 0, sockaddrPtr, socklen_t(MemoryLayout<sockaddr_in>.size))
                }
            }
        }
    }
}
