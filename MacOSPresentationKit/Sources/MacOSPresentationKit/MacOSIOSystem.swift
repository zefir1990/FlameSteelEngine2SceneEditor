import PresentationKit

@MainActor
public struct MacOSIOSystem: IOSystem {
    public let widgetsClient: WidgetsClient
    public let macosInteractor: MacOSInteractor
    private let mainView: any View

    public init(
        widgetsClient: WidgetsClient, 
        macosInteractor: MacOSInteractor,
        mainView: any View
    ) {
        self.widgetsClient = widgetsClient
        self.macosInteractor = macosInteractor
        self.mainView = mainView
        self.macosInteractor.start()
    }

    public func viewRenderer(parent: (any View)?) -> any ViewRenderer {
        return MacOSViewRenderer(parent: parent, ioSystem: self)
    }

    public func shutdown() {
        widgetsClient.shutdown()
        macosInteractor.stop()
    }

    public func handle(event: ApplicationEvent) {
        switch event {
        case .applicationCalled:
            let renderer = viewRenderer(parent: nil)
            renderer.render(mainView)
        }
    }
}
