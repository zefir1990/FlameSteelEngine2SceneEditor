public struct DefaultIOSystem: IOSystem {
    public init() {}
    public func shutdown() {}
    public func viewRenderer(parent: (any View)?) -> any ViewRenderer {
        return ConsoleViewRenderer(parent: parent, ioSystem: self)
    }    
    public func handle(event: ApplicationEvent) {
        switch event {
        case .applicationCalled:
            print("Application called")
        }
    }
}