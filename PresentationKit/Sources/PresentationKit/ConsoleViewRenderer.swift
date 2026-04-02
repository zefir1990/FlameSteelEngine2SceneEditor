struct ConsoleViewRenderer: ViewRenderer {
    func render(_ view: any View) {
        print("\(type(of: self)): Rendering view \(type(of: view))")
    }
}