public struct ViewRenderer {
    public init() {}
    
    public func render(_ view: any View) {
        print("ViewRenderer: Rendering view \(type(of: view))")
    }
}
