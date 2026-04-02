public struct Panel: View {
    public let children: [any View]

    public init(@ViewBuilder _ content: () -> ViewGroup) {
        self.children = content().views
    }

    public func accept(_ visitor: any ViewVisitor) {
        visitor.visit(self)
    }
}
