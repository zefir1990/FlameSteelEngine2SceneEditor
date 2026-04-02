public protocol ViewVisitor {
    func visit(_ button: Button)
    func visit(_ text: Text)
    func visit(_ panel: Panel)
    func visit(_ viewGroup: ViewGroup)
    func visit(_ modifiedView: ModifiedView)
    func visit(_ emptyView: EmptyView)
    func visit(_ objectsTreeView: ObjectsTreeView)
    func visit(_ view: any View)
}
