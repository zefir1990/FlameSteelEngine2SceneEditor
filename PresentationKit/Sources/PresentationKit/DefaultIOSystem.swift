@MainActor
public struct DefaultIOSystem: IOSystem {
    private let mainView: (any View)?

    public init(mainView: (any View)? = nil) {
        self.mainView = mainView
    }

    public func shutdown() {}

    public func viewRenderer(parent: (any View)?) -> any ViewRenderer {
        return ConsoleViewRenderer(parent: parent, ioSystem: self)
    }    

    public func handle(event: ApplicationEvent) {
        switch event {
        case .applicationCalled:
            print("Application called")
            if let mainView = mainView {
                let renderer = viewRenderer(parent: nil)
                renderer.render(mainView)
            }
        }
    }
}