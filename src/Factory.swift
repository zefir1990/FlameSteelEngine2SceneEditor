import PresentationKit

#if os(macOS)
import MacOSPresentationKit
#elseif os(Windows)
import WindowsPresentationKit
#elseif os(Linux)
import LinuxPresentationKit
#endif

public enum Factory {
    public static func viewRenderer() -> ViewRenderer {
        #if os(macOS)
        return MacOSViewRenderer()
        #elseif os(Windows)
        return WindowsViewRenderer()
        #elseif os(Linux)
        return LinuxViewRenderer()
        #else
        // Fallback or default renderer if any
        return ConsoleViewRenderer()
        #endif
    }
}
