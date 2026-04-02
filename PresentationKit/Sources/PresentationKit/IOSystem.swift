public protocol IOSystem {
    func viewRenderer(parent: (any View)?) -> any ViewRenderer
    func shutdown()
    func handle(event: ApplicationEvent)
}