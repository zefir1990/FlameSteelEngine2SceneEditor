import Foundation

@UUIDId
public struct ViewGroup: View {
    public let views: [any View]
    public init(_ views: [any View]) {
        self.views = views
    }

    public func accept(_ visitor: any ViewVisitor) {
        visitor.visit(self)
    }
}
