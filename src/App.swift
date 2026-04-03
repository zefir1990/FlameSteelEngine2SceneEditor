import PresentationKit
import EBox
import Foundation

@MainActor
struct App {
    @MainActor
    func setup() {
        print("Welcome to Flame Steel Engine 2 Scene Editor")
        EBox.initialize(localizationBundle: Bundle.module)
        let ioSystem = Factory.uikitIOSystem()
        ioSystem.handle(event: .applicationCalled)
    }

    @MainActor
    func run() {
        setup()
        RunLoop.main.run()
    }
}
