public struct EmptyView: View {
    public init() {}
    public var presentation: EmptyView {
        return self
    }

    public func accept(_ visitor: any ViewVisitor) {
        visitor.visit(self)
    }
}
