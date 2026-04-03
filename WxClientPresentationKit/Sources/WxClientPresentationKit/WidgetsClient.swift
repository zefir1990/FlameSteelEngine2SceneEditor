#if os(Windows)
import WinSDK
#elseif os(macOS) || os(iOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif
import Foundation

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
        #if os(Windows)
        sendWindowsUDP(message)
        #else
        sendPOSIXUDP(message)
        #endif
    }

    #if os(Windows)
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
    #else
    private func sendPOSIXUDP(_ message: String) {
        let sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        if sock < 0 { return }
        defer { close(sock) }

        var addr = sockaddr_in()
        #if os(macOS) || os(iOS)
        addr.sin_len = __uint8_t(MemoryLayout<sockaddr_in>.size)
        #endif
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
    #endif
}
