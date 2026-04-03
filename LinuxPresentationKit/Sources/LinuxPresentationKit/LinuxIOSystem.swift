import PresentationKit

@MainActor
public struct LinuxIOSystem: IOSystem {
    private let mainView: any View

    public init(mainView: any View) {
        self.mainView = mainView
    }

    public func viewRenderer(parent: (any View)?) -> any ViewRenderer {
        return LinuxViewRenderer(parent: parent, ioSystem: self)
    }

    public func shutdown() {}

    public func handle(event: ApplicationEvent) {
        switch event {
        case .applicationCalled:
            let renderer = viewRenderer(parent: nil)
            renderer.render(mainView)
        }
    }
}
