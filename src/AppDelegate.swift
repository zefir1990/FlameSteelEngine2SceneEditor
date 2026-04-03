#if targetEnvironment(macCatalyst) || os(iOS)
import UIKit

@MainActor
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var app: App?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if PresentationKitFrontend_SwiftUI
        self.app = App(ioSystem: Factory.swiftuiIOSystem())
        #else
        self.app = App(ioSystem: Factory.uikitIOSystem())
        #endif
        return true
    }
}
#endif
