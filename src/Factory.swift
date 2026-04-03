import PresentationKit
import WxClientPresentationKit

#if PresentationKitFrontend_UIKit
import UIKitPresentationKit
#elseif PresentationKitFrontend_SwiftUI
import SwiftUIPresentationKit
#endif

public enum Factory {
    @MainActor
    public static func wxIOSystem() -> (any IOSystem) {
        let client = WidgetsClient()
        let interactor = WxInteractor()
        let ioSystem = WxIOSystem(widgetsClient: client, interactor: interactor, mainView: MainScreen())
        return ioSystem
    }

    #if PresentationKitFrontend_UIKit
    @MainActor
    public static func uikitIOSystem() -> (any IOSystem) {
        return UIKitIOSystem(mainView: MainScreen())
    }
    #elseif PresentationKitFrontend_SwiftUI
    @MainActor
    public static func swiftuiIOSystem() -> (any IOSystem) {
        return SwiftUIIOSystem(mainView: MainScreen())
    }
    #endif
}
