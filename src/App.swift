import PresentationKit
import EBox
import Foundation

struct App {
    func run() async {
        print("Welcome to Flame Steel Engine 2 Scene Editor")
        
        // Initialize global resources (e.g., localization)
        EBox.initialize(localizationBundle: Bundle.module)
        
        // Setup the renderer and its platform-specific execution context
        let (renderer, context) = Factory.viewRenderer()
        
        // Initial render pass (synchronous traversal)
        renderer.render(MainScreen())
        
        // Perform a synchronous shutdown of the context.
        // With the UDP protocol, connection teardown is immediate and non-blocking.
        context.shutdown()
    }
}
