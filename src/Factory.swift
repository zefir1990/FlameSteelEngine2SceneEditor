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
        return MacOSViewRenderer(parent: nil)
        #elseif os(Windows)
        return WindowsViewRenderer(parent: nil)
        #elseif os(Linux)
        return LinuxViewRenderer(parent: nil)
        #else
        return ConsoleViewRenderer(parent: nil)
        #endif
    }
}
