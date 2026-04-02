import PresentationKit

public class WindowsViewRenderer: ViewRenderer {
    private let layer: Int
    private let parentView: (any View)?
    public let context: any ViewRendererContext

    private var windowsContext: WindowsViewRendererContext {
        return context as! WindowsViewRendererContext
    }

    private func indent() -> String {
        return String(repeating: "  ", count: layer)
    }

    public required init(parent: (any View)?, context: any ViewRendererContext) {
        self.parentView = parent
        self.context = context
        self.layer = 0
    }

    private init(parent: (any View)?, layer: Int, context: any ViewRendererContext) {
        self.parentView = parent
        self.layer = layer
        self.context = context
    }

    public func render(_ view: any View) {
        print("1\(indent())\(type(of: self)): Rendering view \(type(of: view))")
        view.accept(self)
    }

    public func visit(_ button: Button) {
        print("2\(indent())\(type(of: self)): visit Button")
        let subRenderer = WindowsViewRenderer(parent: button, layer: layer + 1, context: context)
        subRenderer.render(button.label)
    }

    public func visit(_ text: Text) {
        print("3\(indent())\(type(of: self)): visit Text - \(text.content)")
    }

    public func visit(_ panel: Panel) {
        print("4\(indent())\(type(of: self)): visit Panel - \(panel.children.count) children")
        for child in panel.children {
            let subRenderer = WindowsViewRenderer(parent: panel, layer: layer + 1, context: context)
            subRenderer.render(child)
        }
    }

    public func visit(_ viewGroup: ViewGroup) {
        print("5\(indent())\(type(of: self)): visit ViewGroup - \(viewGroup.views.count) views")
        for view in viewGroup.views {
            let subRenderer = WindowsViewRenderer(parent: viewGroup, layer: layer + 1, context: context)
            subRenderer.render(view)
        }
    }

    public func visit(_ modifiedView: ModifiedView) {
        print("6\(indent())\(type(of: self)): visit ModifiedView - size: \(modifiedView.size)")
        let subRenderer = WindowsViewRenderer(parent: modifiedView, layer: layer + 1, context: context)
        subRenderer.render(modifiedView._content)
    }

    public func visit(_ emptyView: EmptyView) {
        print("7\(indent())\(type(of: self)): visit EmptyView")
    }

    public func visit(_ objectsTreeView: ObjectsTreeView) {
        print("8\(indent())\(type(of: self)): visit ObjectsTreeView")
        let subRenderer = WindowsViewRenderer(parent: objectsTreeView, layer: layer + 1, context: context)
        subRenderer.render(objectsTreeView.subviews)
    }

    public func visit(_ view: any View) {
        print("9\(indent())\(type(of: self)): visit \(type(of: view))")

        if parentView == nil {
            print("No parent view -> render as window")
            
            // Invoke the synchronous UDP client from the platform context
            let title = "\(type(of: view))"
            windowsContext.widgetsClient.createWindow(title: title, width: 800, height: 600)
        }

        let subRenderer = WindowsViewRenderer(parent: view, layer: layer + 1, context: context)
        subRenderer.render(view.subviews)
    }
}
