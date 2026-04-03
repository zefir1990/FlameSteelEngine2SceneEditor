import PresentationKit

@MainActor
public struct WxIOSystem: IOSystem {
    public let widgetsClient: WidgetsClient
    public let interactor: WxInteractor
    private let mainView: any View

    public init(
        widgetsClient: WidgetsClient, 
        interactor: WxInteractor,
        mainView: any View
    ) {
        self.widgetsClient = widgetsClient
        self.interactor = interactor
        self.mainView = mainView
        self.interactor.start()
    }

    public func viewRenderer(parent: (any View)?) -> any ViewRenderer {
        return WxViewRenderer(parent: parent, ioSystem: self)
    }

    public func shutdown() {
        widgetsClient.shutdown()
        interactor.stop()
    }

    public func handle(event: ApplicationEvent) {
        switch event {
        case .applicationCalled:
            let renderer = viewRenderer(parent: nil)
            renderer.render(mainView)
        }
    }
}
