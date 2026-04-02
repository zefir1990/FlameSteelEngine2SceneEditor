import PresentationKit

struct App {
    func run() {
        print("Welcome to Flame Steel Engine 2 Scene Editor")
        let renderer = ViewRenderer()
        renderer.render(MainScreen())
    }
}
