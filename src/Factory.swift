import PresentationKit

#if os(macOS)
import MacOSPresentationKit
#elseif os(Windows)
import WindowsPresentationKit
#elseif os(Linux)
import LinuxPresentationKit
#endif

public enum Factory {
    public static func viewRenderer() -> (any ViewRenderer) {
        #if os(macOS)
        let context = DefaultViewRendererContext()
        return MacOSViewRenderer(parent: nil, context: context)
        #elseif os(Windows)
        let client = WidgetsClient() // Host/port can be customized
        let interactor = WindowsInteractor()
        let context = WindowsViewRendererContext(widgetsClient: client, interactor: interactor)
        return WindowsViewRenderer(parent: nil, context: context)
        #elseif os(Linux)
        let context = DefaultViewRendererContext()
        return LinuxViewRenderer(parent: nil, context: context)
        #else
        let context = DefaultViewRendererContext()
        return ConsoleViewRenderer(parent: nil, context: context)
        #endif
    }
}
