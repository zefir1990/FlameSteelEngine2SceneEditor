public class ConsoleViewRenderer: ViewRenderer {
    private var depth = 0
    private func indent() -> String {
        return String(repeating: "  ", count: depth)
    }

    public required init(parent: (any View)? = nil) {}

    public func render(_ view: any View) {
        depth = 0
        print("\(indent())\(type(of: self)): Rendering view \(type(of: view))")
        view.accept(self)
    }

    public func visit(_ button: Button) {
        print("\(indent())\(type(of: self)): visit Button")
        depth += 1
        button.label.accept(self)
        depth -= 1
    }

    public func visit(_ text: Text) {
        print("\(indent())\(type(of: self)): visit Text - \(text.content)")
    }

    public func visit(_ panel: Panel) {
        print("\(indent())\(type(of: self)): visit Panel")
        depth += 1
        for child in panel.children {
            child.accept(self)
        }
        depth -= 1
    }

    public func visit(_ viewGroup: ViewGroup) {
        print("\(indent())\(type(of: self)): visit ViewGroup - \(viewGroup.views.count) views")
        depth += 1
        for view in viewGroup.views {
            view.accept(self)
        }
        depth -= 1
    }

    public func visit(_ modifiedView: ModifiedView) {
        print("\(indent())\(type(of: self)): visit ModifiedView - size: \(modifiedView.size)")
        depth += 1
        modifiedView._content.accept(self)
        depth -= 1
    }

    public func visit(_ emptyView: EmptyView) {}

    public func visit(_ objectsTreeView: ObjectsTreeView) {
        print("\(indent())\(type(of: self)): visit ObjectsTreeView")
        depth += 1
        objectsTreeView.erasedPresentation.accept(self)
        depth -= 1
    }

    public func visit(_ view: any View) {
        print("\(indent())\(type(of: self)): visit \(type(of: view))")
        depth += 1
        view.erasedPresentation.accept(self)
        depth -= 1
    }
}