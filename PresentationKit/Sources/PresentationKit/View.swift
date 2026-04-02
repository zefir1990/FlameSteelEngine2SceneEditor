public protocol View {
    associatedtype Presentation: View
    @ViewBuilder var presentation: Presentation { get }
    var erasedPresentation: any View { get }

    func accept(_ visitor: any ViewVisitor)
}

extension View {
    public var erasedPresentation: any View { presentation }
}

extension View where Presentation == EmptyView {
    public var presentation: EmptyView {
        return EmptyView()
    }
}
