struct Presentation {
    let views: [View]
    
    init(@ViewBuilder _ content: () -> [View]) {
        self.views = content()
    }
    
    func bind(to context: MainScreenContext) {
        print("Binding presentation to context")
    }
}
