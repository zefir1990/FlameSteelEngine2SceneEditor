public struct Text: View {
    public let content: String

    public init(_ content: String) {
        self.content = content
    }

    public func accept(_ visitor: any ViewVisitor) {
        visitor.visit(self)
    }
}
