import PresentationKit

#if os(macOS)
import MacOSPresentationKit
#elseif os(Windows)
import WindowsPresentationKit
#elseif os(Linux)
import LinuxPresentationKit
#endif

public enum Factory {
    public static func ioSystem() -> (any IOSystem) {
        #if os(macOS)
        let ioSystem = DefaultIOSystem()
        return MacOSViewRenderer(parent: nil, ioSystem: ioSystem)
        #elseif os(Windows)
        let client = WidgetsClient()
        let interactor = WindowsInteractor()
        let ioSystem = WindowsIOSystem(widgetsClient: client, interactor: interactor)
        return ioSystem
        #elseif os(Linux)
        let ioSystem = DefaultIOSystem()
        return LinuxViewRenderer(parent: nil, ioSystem: ioSystem)
        #else
        let context = DefaultIOSystem()
        return ConsoleViewRenderer(parent: nil, ioSystem: ioSystem)
        #endif
    }
}
