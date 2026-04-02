import Foundation

@UUIDId
public struct Button: View {
    public let action: () -> Void
    public let label: any View

    public init(_ action: @escaping () -> Void, @ViewBuilder label: () -> ViewGroup) {
        self.action = action
        self.label = label().views.first!
    }

    public func accept(_ visitor: any ViewVisitor) {
        visitor.visit(self)
    }
}
