import PresentationKit

@MainActor
public class MacOSViewRenderer: ViewRenderer {
    private let layer: Int
    private let parentView: (any View)?
    private let parentId: String?
    public let ioSystem: any IOSystem

    private var macosContext: MacOSIOSystem {
        return ioSystem as! MacOSIOSystem
    }

    private func indent() -> String {
        return String(repeating: "  ", count: layer)
    }

    public required init(parent: (any View)?, ioSystem: any IOSystem) {
        self.parentView = parent
        self.ioSystem = ioSystem
        self.layer = 0
        self.parentId = nil
    }

    private init(parent: (any View)?, layer: Int, ioSystem: any IOSystem, parentId: String?) {
        self.parentView = parent
        self.layer = layer
        self.ioSystem = ioSystem
        self.parentId = parentId
    }

    public func render(_ view: any View) {
        view.accept(self)
    }

    public func visit(_ button: Button) {
        let currentId = button.id.uuidString
        print("\(indent())visit Button (ID: \(currentId), Parent: \(parentId ?? "none"))")
        
        let extractor = SimpleTextExtractor()
        button.label.accept(extractor)
        let label = extractor.text ?? "Button"

        macosContext.macosInteractor.registerAction(id: button.id, action: button.action)

        macosContext.widgetsClient.send(command: "AddButton", args: [
            "id": currentId,
            "parentId": parentId ?? "",
            "label": label
        ])
    }

    public func visit(_ text: Text) {
        let currentId = text.id.uuidString
        print("\(indent())visit Text (ID: \(currentId), Parent: \(parentId ?? "none")) - \(text.content)")
        
        macosContext.widgetsClient.send(command: "AddText", args: [
            "id": currentId,
            "parentId": parentId ?? "",
            "text": text.content
        ])
    }

    public func visit(_ panel: Panel) {
        let currentId = panel.id.uuidString
        print("\(indent())visit Panel (ID: \(currentId), Parent: \(parentId ?? "none"))")
        
        macosContext.widgetsClient.send(command: "AddPanel", args: [
            "id": currentId,
            "parentId": parentId ?? ""
        ])

        for child in panel.children {
            let subRenderer = MacOSViewRenderer(parent: panel, layer: layer + 1, ioSystem: ioSystem, parentId: currentId)
            subRenderer.render(child)
        }
    }

    public func visit(_ viewGroup: ViewGroup) {
        let currentId = viewGroup.id.uuidString
        print("\(indent())visit ViewGroup (ID: \(currentId), Parent: \(parentId ?? "none"))")
        
        macosContext.widgetsClient.send(command: "AddContainer", args: [
            "id": currentId,
            "parentId": parentId ?? "",
            "type": "vertical"
        ])

        for view in viewGroup.views {
            let subRenderer = MacOSViewRenderer(parent: viewGroup, layer: layer + 1, ioSystem: ioSystem, parentId: currentId)
            subRenderer.render(view)
        }
    }

    public func visit(_ modifiedView: ModifiedView) {
        let subRenderer = MacOSViewRenderer(parent: modifiedView, layer: layer + 1, ioSystem: ioSystem, parentId: parentId)
        subRenderer.render(modifiedView._content)
    }

    public func visit(_ emptyView: EmptyView) {}

    public func visit(_ objectsTreeView: ObjectsTreeView) {
        let currentId = objectsTreeView.id.uuidString
        print("\(indent())visit ObjectsTreeView (ID: \(currentId), Parent: \(parentId ?? "none"))")
        
        macosContext.widgetsClient.send(command: "AddText", args: [
            "id": currentId,
            "parentId": parentId ?? "",
            "text": "[Hierarchical Objects Tree]"
        ])

        let subRenderer = MacOSViewRenderer(parent: objectsTreeView, layer: layer + 1, ioSystem: ioSystem, parentId: currentId)
        subRenderer.render(objectsTreeView.subviews)
    }

    public func visit(_ view: any View) {
        let currentId = view.id.uuidString
        if parentView == nil {
            print("Rendering root window (ID: \(currentId))")
            
            macosContext.widgetsClient.send(command: "AddWindow", args: [
                "id": currentId,
                "title": "\(type(of: view))"
            ])
        }

        let subRenderer = MacOSViewRenderer(parent: view, layer: layer + 1, ioSystem: ioSystem, parentId: currentId)
        subRenderer.render(view.subviews)
    }
}

@MainActor
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
