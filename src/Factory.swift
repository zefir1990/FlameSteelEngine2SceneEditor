import PresentationKit
import WxClientPresentationKit

#if os(macOS)
import SwiftUIPresentationKit
#if canImport(UIKit)
import UIKitPresentationKit
#endif
#endif

public enum Factory {
    @MainActor
    public static func wxIOSystem() -> (any IOSystem) {
        let client = WidgetsClient()
        let interactor = WxInteractor()
        let ioSystem = WxIOSystem(widgetsClient: client, interactor: interactor, mainView: MainScreen())
        return ioSystem
    }

    #if os(macOS)
    @MainActor
    public static func uikitIOSystem() -> (any IOSystem) {
        #if canImport(UIKit)
        return UIKitIOSystem(mainView: MainScreen())
        #else
        print("Warning: UIKit is not available on this platform/target. Build for Mac Catalyst to use UIKitPresentationKit. Switching to SwiftUI.")
        return SwiftUIIOSystem(mainView: MainScreen()) // Fallback to SwiftUI so it still runs
        #endif
    }

    @MainActor
    public static func swiftuiIOSystem() -> (any IOSystem) {
        return SwiftUIIOSystem(mainView: MainScreen())
    }
    #endif
}
