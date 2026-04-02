public enum Factory {
    public static func viewRenderer() -> ViewRenderer {
        #if os(macOS)
        return MacOSViewRenderer()
        #elseif os(Windows)
        return WindowsViewRenderer()
        #elseif os(Linux)
        return LinuxViewRenderer()
        #else
        return ConsoleViewRenderer()
        #endif
    }
}