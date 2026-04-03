import PresentationKit
import WxClientPresentationKit

#if targetEnvironment(macCatalyst)
import UIKitPresentationKit
#elseif os(macOS)
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

    #if targetEnvironment(macCatalyst)
    @MainActor
    public static func uikitIOSystem() -> (any IOSystem) {
        return UIKitIOSystem(mainView: MainScreen())
    }
    #elseif os(macOS)
    @MainActor
    public static func swiftuiIOSystem() -> (any IOSystem) {
        return SwiftUIIOSystem(mainView: MainScreen())
    }

    @MainActor
    public static func uikitIOSystem() -> (any IOSystem) {
        print("Warning: UIKit is not available on native macOS. Switching to SwiftUI.")
        return swiftuiIOSystem()
    }
    #endif
}
