public struct DefaultIOSystem: IOSystem {
    public init() {}
    public func shutdown() {}
    public func viewRenderer(parent: (any View)?) -> any ViewRenderer {
        return ConsoleViewRenderer(parent: parent, ioSystem: self)
    }    
}