public protocol ViewRenderer {
    init(parent: (any View)?)
    func render(_ view: any View)
}
