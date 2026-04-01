public struct Button: View {
    public let action: () -> Void
    public let label: View

    public init(_ action: @escaping () -> Void, @ViewBuilder label: () -> [View]) {
        self.action = action
        self.label = label().first!
    }
}
