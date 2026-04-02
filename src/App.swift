import PresentationKit
import EBox
import Foundation

struct App {
    func run() {
        print("Welcome to Flame Steel Engine 2 Scene Editor")
        EBox.initialize(localizationBundle: Bundle.module)
        let renderer = ViewRenderer()
        renderer.render(MainScreen())
    }
}
