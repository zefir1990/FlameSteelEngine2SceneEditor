public protocol View {
    associatedtype Presentation: View
    @ViewBuilder var presentation: Presentation { get }
}

extension View where Presentation == EmptyView {
    public var presentation: EmptyView {
        return EmptyView()
    }
}
