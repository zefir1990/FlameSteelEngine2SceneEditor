public struct ConsoleViewRenderer: ViewRenderer {
    public init(parent: (any View)? = nil) {}
    public func render(_ view: any View) {
        print("\(type(of: self)): Rendering view \(type(of: view))")
    }
}