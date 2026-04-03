import PresentationKit
import WxClientPresentationKit

#if os(macOS)
import SwiftUIPresentationKit
#endif

public enum Factory {
    @MainActor
    public static func ioSystem() -> (any IOSystem) {
        #if os(macOS)
        return SwiftUIIOSystem(mainView: MainScreen())
        #else
        let client = WidgetsClient()
        let interactor = WxInteractor()
        let ioSystem = WxIOSystem(widgetsClient: client, interactor: interactor, mainView: MainScreen())
        return ioSystem
        #endif
    }
}
