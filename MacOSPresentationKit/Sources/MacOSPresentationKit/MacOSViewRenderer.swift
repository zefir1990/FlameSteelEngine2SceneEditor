import PresentationKit

public class MacOSViewRenderer: ViewRenderer {
    private let depth: Int
    private let parentView: (any View)?

    private func indent() -> String {
        return String(repeating: "  ", count: depth)
    }

    public required init(parent: (any View)?) {
        self.parentView = parent
        self.depth = 0
    }

    private init(parent: (any View)?, depth: Int) {
        self.parentView = parent
        self.depth = depth
    }

    public func render(_ view: any View) {
        print("\(indent())\(type(of: self)): Rendering view \(type(of: view))")
        view.accept(self)
    }

    public func visit(_ button: Button) {
        print("\(indent())\(type(of: self)): visit Button")
        let subRenderer = MacOSViewRenderer(parent: button, depth: self.depth + 1)
        subRenderer.render(button.label)
    }

    public func visit(_ text: Text) {
        print("\(indent())\(type(of: self)): visit Text - \(text.content)")
    }

    public func visit(_ panel: Panel) {
        print("\(indent())\(type(of: self)): visit Panel")
        for child in panel.children {
            let subRenderer = MacOSViewRenderer(parent: panel, depth: self.depth + 1)
            subRenderer.render(child)
        }
    }

    public func visit(_ viewGroup: ViewGroup) {
        print("\(indent())\(type(of: self)): visit ViewGroup")
        for view in viewGroup.views {
            let subRenderer = MacOSViewRenderer(parent: viewGroup, depth: self.depth + 1)
            subRenderer.render(view)
        }
    }

    public func visit(_ modifiedView: ModifiedView) {
        print("\(indent())\(type(of: self)): visit ModifiedView - size: \(modifiedView.size)")
        let subRenderer = MacOSViewRenderer(parent: modifiedView, depth: self.depth + 1)
        subRenderer.render(modifiedView._content)
    }

    public func visit(_ emptyView: EmptyView) {}

    public func visit(_ objectsTreeView: ObjectsTreeView) {
        print("\(indent())\(type(of: self)): visit ObjectsTreeView")
        let subRenderer = MacOSViewRenderer(parent: objectsTreeView, depth: self.depth + 1)
        subRenderer.render(objectsTreeView.erasedPresentation)
    }

    public func visit(_ view: any View) {
        print("\(indent())\(type(of: self)): visit \(type(of: view))")
        let subRenderer = MacOSViewRenderer(parent: view, depth: self.depth + 1)
        subRenderer.render(view.erasedPresentation)
    }
}
