public struct ModifiedView: View {
    public let _content: any View
    public let size: Size

    public init(_content: any View, size: Size) {
        self._content = _content
        self.size = size
    }
}

public extension View {
    func preferredSize(_ size: Size) -> any View {
        return ModifiedView(_content: self, size: size)
    }
}
