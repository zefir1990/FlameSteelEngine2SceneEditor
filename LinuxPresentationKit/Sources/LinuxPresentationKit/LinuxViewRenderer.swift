import PresentationKit

public class LinuxViewRenderer: ViewRenderer {
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
        let subRenderer = LinuxViewRenderer(parent: button, depth: depth + 1)
        subRenderer.render(button.label)
    }

    public func visit(_ text: Text) {
        print("\(indent())\(type(of: self)): visit Text - \(text.content)")
    }

    public func visit(_ panel: Panel) {
        print("\(indent())\(type(of: self)): visit Panel")
        for child in panel.children {
            let subRenderer = LinuxViewRenderer(parent: panel, depth: depth + 1)
            subRenderer.render(child)
        }
    }

    public func visit(_ viewGroup: ViewGroup) {
        print("\(indent())\(type(of: self)): visit ViewGroup")
        for view in viewGroup.views {
            let subRenderer = LinuxViewRenderer(parent: viewGroup, depth: depth + 1)
            subRenderer.render(view)
        }
    }

    public func visit(_ modifiedView: ModifiedView) {
        print("\(indent())\(type(of: self)): visit ModifiedView - size: \(modifiedView.size)")
        let subRenderer = LinuxViewRenderer(parent: modifiedView, depth: depth + 1)
        subRenderer.render(modifiedView._content)
    }

    public func visit(_ emptyView: EmptyView) {}

    public func visit(_ objectsTreeView: ObjectsTreeView) {
        print("\(indent())\(type(of: self)): visit ObjectsTreeView")
        let subRenderer = LinuxViewRenderer(parent: objectsTreeView, depth: depth + 1)
        subRenderer.render(objectsTreeView.subviews)
    }

    public func visit(_ view: any View) {
        print("\(indent())\(type(of: self)): visit \(type(of: view))")
        let subRenderer = LinuxViewRenderer(parent: view, depth: depth + 1)
        subRenderer.render(view.subviews)
    }
}
