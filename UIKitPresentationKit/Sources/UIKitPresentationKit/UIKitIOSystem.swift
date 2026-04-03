import UIKit
import PresentationKit

@MainActor
public class UIKitIOSystem: IOSystem {
    private let mainView: any PresentationKit.View
    private let renderer: UIKitViewRenderer
    private var window: UIWindow?
    
    public init(mainView: any PresentationKit.View) {
        self.mainView = mainView
        self.renderer = UIKitViewRenderer(parent: mainView, ioSystem: DefaultIOSystem(mainView: mainView))
    }
    
    public func viewRenderer(parent: (any PresentationKit.View)?) -> any ViewRenderer {
        return renderer
    }
    
    public func handle(event: ApplicationEvent) {
        switch event {
        case .applicationCalled:
            startUIKit()
        }
    }
    
    public func shutdown() {
        print("UIKitIOSystem: Shutdown requested.")
    }
    
    private func startUIKit() {
        // This assumes a UIKit environment (like Mac Catalyst) where a UIWindow can be created.
        let window = UIWindow(frame: UIScreen.main.bounds)
        renderer.render(mainView)
        window.rootViewController = renderer.rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
