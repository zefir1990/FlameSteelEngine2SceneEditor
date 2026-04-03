import PresentationKit
import EBox
import Foundation

@MainActor
struct App {
    @MainActor
    func setup(ioSystem: any IOSystem) {
        print("Welcome to Flame Steel Engine 2 Scene Editor")
        EBox.initialize(localizationBundle: Bundle.module)
        ioSystem.handle(event: .applicationCalled)
    }

    @MainActor
    func run(ioSystem: any IOSystem) {
        setup(ioSystem: ioSystem)
        RunLoop.main.run()
    }
}
