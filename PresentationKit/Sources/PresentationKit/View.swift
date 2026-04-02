public protocol View {
    associatedtype Presentation: View
    @ViewBuilder var presentation: Presentation { get }

    func accept(_ visitor: any ViewVisitor)
}

extension View where Presentation == EmptyView {
    public var presentation: EmptyView {
        return EmptyView()
    }
}
