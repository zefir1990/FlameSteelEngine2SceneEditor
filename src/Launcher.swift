import Foundation
import PresentationKit

@main
@MainActor 
struct Launcher {
    static func main() {
        print("Hello Launcher.swift")
        let app = App()
        app.run()
    }
}
