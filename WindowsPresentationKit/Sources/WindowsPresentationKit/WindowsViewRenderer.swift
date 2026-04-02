import PresentationKit

public struct WindowsViewRenderer: ViewRenderer {
    public init(parent: (any View)?) {}

    public func render(_ view: any View) {
        print("\(type(of: self)): Rendering view \(type(of: view))")
        view.accept(self)
    }

    public func visit(_ button: Button) {
        print("\(type(of: self)): visit Button")
    }

    public func visit(_ text: Text) {
        print("\(type(of: self)): visit Text - \(text.content)")
    }

    public func visit(_ panel: Panel) {
        print("\(type(of: self)): visit Panel - \(panel.children.count) children")
        for child in panel.children {
            child.accept(self)
        }
    }

    public func visit(_ viewGroup: ViewGroup) {
        print("\(type(of: self)): visit ViewGroup - \(viewGroup.views.count) views")
        for view in viewGroup.views {
            view.accept(self)
        }
    }

    public func visit(_ modifiedView: ModifiedView) {
        print("\(type(of: self)): visit ModifiedView - size: \(modifiedView.size)")
        modifiedView._content.accept(self)
    }

    public func visit(_ emptyView: EmptyView) {
        // No-op
    }

    public func visit(_ objectsTreeView: ObjectsTreeView) {
        print("\(type(of: self)): visit ObjectsTreeView")
    }
}
