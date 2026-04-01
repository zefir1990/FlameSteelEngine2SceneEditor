struct Factory {
    static func makeApp() -> App {
        #if os(Windows)
        return WindowsApp()
        #elseif os(macOS)
        return macOSApp()
        #elseif os(Linux)
        return LinuxApp()
        #endif
    }
}