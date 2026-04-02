import Foundation

#if os(Windows)
import WinSDK
#elseif os(Linux)
import Glibc
#elseif os(macOS)
import Darwin
#endif

/// A lightweight UDP client designed to communicate with the WidgetsServer.
/// Since UDP is a non-blocking protocol, this client performs synchronous message 
/// delivery, ensuring the UI rendering pass remains efficient and predictable.
public struct WidgetsClient {
    private let host: String
    private let port: Int

    public init(host: String = "127.0.0.1", port: Int = 50051) {
        self.host = host
        self.port = port
    }

    /// Sends a CreateWindow command to the server via a UDP packet (synchronous).
    public func createWindow(title: String, width: Int32, height: Int32) {
        let payload: [String: Any] = [
            "command": "CreateWindow",
            "title": title,
            "width": width,
            "height": height
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("WidgetsClient: Failed to serialize command payload.")
            return
        }

        print("WidgetsClient: Sending UDP command to \(host):\(port)...")
        sendUDP(jsonString)
    }

    public func shutdown() {
        print("WidgetsClient: UDP gRPC-less shutdown sequence complete.")
    }

    // --- Private Socket Implementation ---

    private func sendUDP(_ message: String) {
        #if os(Windows)
        sendWindowsUDP(message)
        #else
        sendPosixUDP(message)
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
    #endif

    #if !os(Windows)
    private func sendPosixUDP(_ message: String) {
        let sock = socket(AF_INET, SOCK_DGRAM, 0)
        if sock < 0 { return }
        defer { close(sock) }

        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(port).bigEndian
        inet_pton(AF_INET, host, &addr.sin_addr)

        _ = message.withCString { cString in
            withUnsafePointer(to: &addr) { addrPtr in
                addrPtr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockaddrPtr in
                    sendto(sock, cString, message.utf8.count, 0, sockaddrPtr, socklen_t(MemoryLayout<sockaddr_in>.size))
                }
            }
        }
    }
    #endif
}
