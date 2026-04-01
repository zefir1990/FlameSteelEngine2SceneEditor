public struct Panel: View {
    public let children: [View]

    public init(@ViewBuilder _ content: () -> [View]) {
        self.children = content()
    }
}
