import PresentationKit

public struct WindowsViewRendererContext: ViewRendererContext {
    public let widgetsClient: WidgetsClient
    public let interactor: WindowsInteractor

    public init(widgetsClient: WidgetsClient, interactor: WindowsInteractor) {
        self.widgetsClient = widgetsClient
        self.interactor = interactor
        self.interactor.start()
    }

    public func shutdown() {
        widgetsClient.shutdown()
        interactor.stop()
    }
}
