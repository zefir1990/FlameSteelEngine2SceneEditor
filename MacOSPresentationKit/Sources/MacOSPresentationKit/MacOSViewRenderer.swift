import PresentationKit

public struct MacOSViewRenderer: ViewRenderer {
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
        print("\(type(of: self)): visit Panel")
        for child in panel.children {
            child.accept(self)
        }
    }

    public func visit(_ viewGroup: ViewGroup) {
        for view in viewGroup.views {
            view.accept(self)
        }
    }

    public func visit(_ modifiedView: ModifiedView) {
        modifiedView._content.accept(self)
    }

    public func visit(_ emptyView: EmptyView) {}

    public func visit(_ objectsTreeView: ObjectsTreeView) {
        print("\(type(of: self)): visit ObjectsTreeView")
    }

    public func visit(_ view: any View) {
        print("\(type(of: self)): visit \(type(of: view))")
    }
}
