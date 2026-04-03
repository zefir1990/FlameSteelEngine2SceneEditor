import ReactiveTech

@MainActor
public struct SimpleTextExtractor: ViewVisitor {
    public let text = Binding<String?>(nil)

    public init() {}

    public func visit(_ button: Button) { button.label.accept(self) }
    public func visit(_ text: Text) { if self.text.value == nil { self.text.value = text.content } }
    public func visit(_ panel: Panel) { for child in panel.children { if self.text.value == nil { child.accept(self) } } }
    public func visit(_ viewGroup: ViewGroup) { for view in viewGroup.views { if self.text.value == nil { view.accept(self) } } }
    public func visit(_ modifiedView: ModifiedView) { modifiedView._content.accept(self) }
    public func visit(_ emptyView: EmptyView) {}
    public func visit(_ objectsTreeView: ObjectsTreeView) {}
    public func visit(_ view: any View) { view.subviews.accept(self) }
}