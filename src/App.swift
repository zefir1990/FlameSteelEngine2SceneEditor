import PresentationKit
import EBox
import Foundation

@MainActor
class App {
    private let ioSystem: any IOSystem

    public init(ioSystem: any IOSystem) {
        self.ioSystem = ioSystem
        print("Welcome to Flame Steel Engine 2 Scene Editor")
        EBox.initialize(localizationBundle: Bundle.module)
        ioSystem.handle(event: .applicationCalled)
    }

    @MainActor
    func run() {
        RunLoop.main.run()
    }
}
