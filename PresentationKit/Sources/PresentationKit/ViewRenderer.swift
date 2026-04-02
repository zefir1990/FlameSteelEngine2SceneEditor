public protocol ViewRenderer: ViewVisitor {
    init(parent: (any View)?)
    func render(_ view: any View)
}
