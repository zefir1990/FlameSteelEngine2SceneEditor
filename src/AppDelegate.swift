#if targetEnvironment(macCatalyst) || os(iOS)
import UIKit

@MainActor
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let app = App()
        app.setup(ioSystem: Factory.uikitIOSystem())
        return true
    }
}
#endif
