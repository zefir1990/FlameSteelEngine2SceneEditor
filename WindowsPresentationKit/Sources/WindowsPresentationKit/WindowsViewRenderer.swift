import PresentationKit
import Foundation

public class WindowsViewRenderer: ViewRenderer {
    private let layer: Int
    private let parentView: (any View)?
    private let parentId: String?
    private let currentId: String
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
        self.parentId = nil
        self.currentId = UUID().uuidString
    }

    private init(parent: (any View)?, layer: Int, context: any ViewRendererContext, parentId: String?) {
        self.parentView = parent
        self.layer = layer
        self.context = context
        self.parentId = parentId
        self.currentId = UUID().uuidString
    }

    public func render(_ view: any View) {
        // Core rendering starts by visiting the view node
        view.accept(self)
    }

    public func visit(_ button: Button) {
        print("\(indent())visit Button (ID: \(currentId), Parent: \(parentId ?? "none"))")
        
        // Extract the first Text label from the button's content
        let extractor = SimpleTextExtractor()
        button.label.accept(extractor)
        let label = extractor.text ?? "Button"

        // Command: AddButton with the extracted label
        windowsContext.widgetsClient.send(command: "AddButton", args: [
            "id": currentId,
            "parentId": parentId ?? "",
            "label": label
        ])

        // We don't recursively render the label view as a separate widget 
        // because its content has been absorbed into the native button label.
    }

    public func visit(_ text: Text) {
// ... (rest of the file remains same, but I'll add the helper class below)
        print("\(indent())visit Text (ID: \(currentId), Parent: \(parentId ?? "none")) - \(text.content)")
        
        // Command: AddText
        windowsContext.widgetsClient.send(command: "AddText", args: [
            "id": currentId,
            "parentId": parentId ?? "",
            "text": text.content
        ])
    }

    public func visit(_ panel: Panel) {
        print("\(indent())visit Panel (ID: \(currentId), Parent: \(parentId ?? "none"))")
        
        // Command: AddPanel
        windowsContext.widgetsClient.send(command: "AddPanel", args: [
            "id": currentId,
            "parentId": parentId ?? ""
        ])

        for child in panel.children {
            let subRenderer = WindowsViewRenderer(parent: panel, layer: layer + 1, context: context, parentId: currentId)
            subRenderer.render(child)
        }
    }

    public func visit(_ viewGroup: ViewGroup) {
        print("\(indent())visit ViewGroup (ID: \(currentId), Parent: \(parentId ?? "none"))")
        
        // Command: AddContainer (Vertical stack by default)
        windowsContext.widgetsClient.send(command: "AddContainer", args: [
            "id": currentId,
            "parentId": parentId ?? "",
            "type": "vertical"
        ])

        for view in viewGroup.views {
            let subRenderer = WindowsViewRenderer(parent: viewGroup, layer: layer + 1, context: context, parentId: currentId)
            subRenderer.render(view)
        }
    }

    public func visit(_ modifiedView: ModifiedView) {
        // Modified views typically adjust their child; for now, we just pass through
        let subRenderer = WindowsViewRenderer(parent: modifiedView, layer: layer + 1, context: context, parentId: parentId)
        subRenderer.render(modifiedView._content)
    }

    public func visit(_ emptyView: EmptyView) {}

    public func visit(_ objectsTreeView: ObjectsTreeView) {
        print("\(indent())visit ObjectsTreeView (ID: \(currentId), Parent: \(parentId ?? "none"))")
        
        // Command: AddText (Placeholder for TreeView)
        windowsContext.widgetsClient.send(command: "AddText", args: [
            "id": currentId,
            "parentId": parentId ?? "",
            "text": "[Hierarchical Objects Tree]"
        ])

        let subRenderer = WindowsViewRenderer(parent: objectsTreeView, layer: layer + 1, context: context, parentId: currentId)
        subRenderer.render(objectsTreeView.subviews)
    }

    public func visit(_ view: any View) {
        if parentView == nil {
            print("Rendering root window (ID: \(currentId))")
            
            // Command: AddWindow (The root frame)
            windowsContext.widgetsClient.send(command: "AddWindow", args: [
                "id": currentId,
                "title": "\(type(of: view))"
            ])
        }

        let subRenderer = WindowsViewRenderer(parent: view, layer: layer + 1, context: context, parentId: currentId)
        subRenderer.render(view.subviews)
    }
}

/// Helper visitor to extract the first Text content found in a view tree.
private class SimpleTextExtractor: ViewVisitor {
    var text: String? = nil

    func visit(_ button: Button) { button.label.accept(self) }
    func visit(_ text: Text) { if self.text == nil { self.text = text.content } }
    func visit(_ panel: Panel) { for child in panel.children { if text == nil { child.accept(self) } } }
    func visit(_ viewGroup: ViewGroup) { for view in viewGroup.views { if text == nil { view.accept(self) } } }
    func visit(_ modifiedView: ModifiedView) { modifiedView._content.accept(self) }
    func visit(_ emptyView: EmptyView) {}
    func visit(_ objectsTreeView: ObjectsTreeView) {}
    func visit(_ view: any View) { view.subviews.accept(self) }
}
