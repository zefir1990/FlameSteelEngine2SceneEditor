public struct ModifiedView: View {
    public let _content: View
    public let size: Size

    public init(_content: View, size: Size) {
        self._content = _content
        self.size = size
    }
}

public extension View {
    func preferredSize(_ size: Size) -> View {
        return ModifiedView(_content: self, size: size)
    }
}
