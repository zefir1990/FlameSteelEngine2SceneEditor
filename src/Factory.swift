import PresentationKit

#if os(macOS)
import MacOSPresentationKit
#elseif os(Windows)
import WindowsPresentationKit
#elseif os(Linux)
import LinuxPresentationKit
#endif

public enum Factory {
    @MainActor
    public static func ioSystem() -> (any IOSystem) {
        #if os(macOS)
        let client = WidgetsClient()
        let interactor = MacOSInteractor()
        return MacOSIOSystem(widgetsClient: client, macosInteractor: interactor, mainView: MainScreen())
        #elseif os(Windows)
        let client = WidgetsClient()
        let interactor = WindowsInteractor()
        let ioSystem = WindowsIOSystem(widgetsClient: client, interactor: interactor, mainView: MainScreen())
        return ioSystem
        #elseif os(Linux)
        return LinuxIOSystem(mainView: MainScreen())
        #else
        return DefaultIOSystem(mainView: MainScreen())
        #endif
    }
}
