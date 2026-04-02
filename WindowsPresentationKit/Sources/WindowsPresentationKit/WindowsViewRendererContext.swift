import PresentationKit

public struct WindowsViewRendererContext: ViewRendererContext {
    public let widgetsClient: WidgetsClient

    public init(widgetsClient: WidgetsClient) {
        self.widgetsClient = widgetsClient
    }

    public func shutdown() {
        widgetsClient.shutdown()
    }
}
