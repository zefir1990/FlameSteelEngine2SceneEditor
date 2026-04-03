import PresentationKit
import EBox
import Foundation

@MainActor
struct App {
    @MainActor
    func run() {
        print("Welcome to Flame Steel Engine 2 Scene Editor")
        EBox.initialize(localizationBundle: Bundle.module)
        let ioSystem = Factory.uikitIOSystem()
        ioSystem.handle(event: .applicationCalled)
        RunLoop.main.run()
    }
}
