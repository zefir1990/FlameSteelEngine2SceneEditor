#if targetEnvironment(macCatalyst) || os(iOS)
import UIKit

@MainActor
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var app: App?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.app = App(ioSystem: Factory.uikitIOSystem())
        return true
    }
}
#endif
