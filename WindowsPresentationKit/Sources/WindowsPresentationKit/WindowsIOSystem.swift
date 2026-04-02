import PresentationKit

public struct WindowsIOSystem: IOSystem {
    public let widgetsClient: WidgetsClient
    public let interactor: WindowsInteractor

    public init(widgetsClient: WidgetsClient, interactor: WindowsInteractor) {
        self.widgetsClient = widgetsClient
        self.interactor = interactor
        self.interactor.start()
    }

    public func viewRenderer(parent: (any View)?) -> any ViewRenderer {
        return WindowsViewRenderer(parent: parent, ioSystem: self)
    }

    public func shutdown() {
        widgetsClient.shutdown()
        interactor.stop()
    }
}
