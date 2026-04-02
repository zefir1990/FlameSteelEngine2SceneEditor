public protocol ViewRendererContext {
    func shutdown()
}

public struct DefaultViewRendererContext: ViewRendererContext {
    public init() {}
    public func shutdown() {}
}

public protocol ViewRenderer: ViewVisitor {
    init(parent: (any View)?, context: any ViewRendererContext)
    var context: any ViewRendererContext { get }
    func render(_ view: any View)
}
