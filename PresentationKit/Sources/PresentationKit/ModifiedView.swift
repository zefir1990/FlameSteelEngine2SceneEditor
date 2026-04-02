import Foundation

@UUIDId
public struct ModifiedView: View {
    public let _content: any View
    public let size: Size

    public init(_content: any View, size: Size) {
        self._content = _content
        self.size = size
    }

    @MainActor
    public func accept(_ visitor: any ViewVisitor) {
        visitor.visit(self)
    }
}

public extension View {
    func preferredSize(_ size: Size) -> any View {
        return ModifiedView(_content: self, size: size)
    }
}
