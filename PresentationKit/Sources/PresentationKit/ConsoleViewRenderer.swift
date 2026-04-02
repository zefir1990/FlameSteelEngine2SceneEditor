public class ConsoleViewRenderer: ViewRenderer {
    private let depth: Int
    public let context: any ViewRendererContext

    private func indent() -> String {
        return String(repeating: "  ", count: depth)
    }

    public required init(parent: (any View)? = nil, context: any ViewRendererContext = DefaultViewRendererContext()) {
        self.context = context
        self.depth = 0
    }

    private init(parent: (any View)?, depth: Int, context: any ViewRendererContext) {
        self.context = context
        self.depth = depth
    }

    public func render(_ view: any View) {
        print("\(indent())\(type(of: self)): Rendering view \(type(of: view))")
        view.accept(self)
    }

    public func visit(_ button: Button) {
        let currentId = button.id.uuidString
        print("\(indent())\(type(of: self)): visit Button (\(currentId))")
        let subRenderer = ConsoleViewRenderer(parent: button, depth: self.depth + 1, context: context)
        subRenderer.render(button.label)
    }

    public func visit(_ text: Text) {
        let currentId = text.id.uuidString
        print("\(indent())\(type(of: self)): visit Text (\(currentId)) - \(text.content)")
    }

    public func visit(_ panel: Panel) {
        let currentId = panel.id.uuidString
        print("\(indent())\(type(of: self)): visit Panel (\(currentId))")
        for child in panel.children {
            let subRenderer = ConsoleViewRenderer(parent: panel, depth: self.depth + 1, context: context)
            subRenderer.render(child)
        }
    }

    public func visit(_ viewGroup: ViewGroup) {
        let currentId = viewGroup.id.uuidString
        print("\(indent())\(type(of: self)): visit ViewGroup (\(currentId))")
        for view in viewGroup.views {
            let subRenderer = ConsoleViewRenderer(parent: viewGroup, depth: self.depth + 1, context: context)
            subRenderer.render(view)
        }
    }

    public func visit(_ modifiedView: ModifiedView) {
        let currentId = modifiedView.id.uuidString
        print("\(indent())\(type(of: self)): visit ModifiedView (\(currentId)) - size: \(modifiedView.size)")
        let subRenderer = ConsoleViewRenderer(parent: modifiedView, depth: self.depth + 1, context: context)
        subRenderer.render(modifiedView._content)
    }

    public func visit(_ emptyView: EmptyView) {}

    public func visit(_ objectsTreeView: ObjectsTreeView) {
        let currentId = objectsTreeView.id.uuidString
        print("\(indent())\(type(of: self)): visit ObjectsTreeView (\(currentId))")
        let subRenderer = ConsoleViewRenderer(parent: objectsTreeView, depth: self.depth + 1, context: context)
        subRenderer.render(objectsTreeView.subviews)
    }

    public func visit(_ view: any View) {
        let currentId = view.id.uuidString
        print("\(indent())\(type(of: self)): visit \(type(of: view)) (\(currentId))")
        let subRenderer = ConsoleViewRenderer(parent: view, depth: self.depth + 1, context: context)
        subRenderer.render(view.subviews)
    }
}