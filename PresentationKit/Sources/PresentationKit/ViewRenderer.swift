@MainActor
public protocol ViewRenderer: ViewVisitor {
    init(parent: (any View)?, ioSystem: any IOSystem)
    var ioSystem: any IOSystem { get }
    func render(_ view: any View)
}
