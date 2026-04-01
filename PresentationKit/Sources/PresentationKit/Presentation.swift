public struct Presentation {
    public let views: [View]
    
    public init(@ViewBuilder _ content: () -> [View]) {
        self.views = content()
    }
}
