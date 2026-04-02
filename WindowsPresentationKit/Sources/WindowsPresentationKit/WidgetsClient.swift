import Foundation
import WinSDK

/// A lightweight UDP client designed to communicate with the WidgetsServer.
/// This client provides a generic mechanism for sending hierarchical UI 
/// construction commands as JSON payloads.
public struct WidgetsClient {
    private let host: String
    private let port: Int

    public init(host: String = "127.0.0.1", port: Int = 50051) {
        self.host = host
        self.port = port
    }

    /// Sends a generic JSON command to the WidgetsServer.
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

    // --- Private Socket Implementation ---

    private func sendUDP(_ message: String) {
        sendWindowsUDP(message)
    }

    private func sendWindowsUDP(_ message: String) {
        var wsaData = WSADATA()
        WSAStartup(0x0202, &wsaData)
        defer { WSACleanup() }

        let sock = socket(Int32(AF_INET), Int32(SOCK_DGRAM), Int32(IPPROTO_UDP.rawValue))
        if sock == INVALID_SOCKET { return }
        defer { closesocket(sock) }

        var addr = sockaddr_in()
        addr.sin_family = ADDRESS_FAMILY(AF_INET)
        addr.sin_port = UInt16(port).bigEndian
        inet_pton(AF_INET, host, &addr.sin_addr)

        _ = message.withCString { cString in
            withUnsafePointer(to: &addr) { addrPtr in
                addrPtr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockaddrPtr in
                    sendto(sock, cString, Int32(message.utf8.count), 0, sockaddrPtr, Int32(MemoryLayout<sockaddr_in>.size))
                }
            }
        }
    }
}
