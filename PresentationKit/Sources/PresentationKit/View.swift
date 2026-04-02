import Foundation

public protocol View {
    var id: Foundation.UUID { get }
    associatedtype Presentation: View
    @ViewBuilder var presentation: Presentation { get }
    var subviews: any View { get }

    func accept(_ visitor: any ViewVisitor)
}

extension View {
    public var subviews: any View { presentation }
}

extension View where Presentation == EmptyView {
    public var presentation: EmptyView {
        return EmptyView()
    }
}
