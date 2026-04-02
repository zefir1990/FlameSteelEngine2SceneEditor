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

// Default fallback for View types without an explicit accept
public extension View {
    func accept(_ visitor: any ViewVisitor) {
        // no-op fallback for views not handled by the visitor
    }
}
