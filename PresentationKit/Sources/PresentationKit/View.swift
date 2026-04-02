public protocol View {
    associatedtype Presentation: View
    @ViewBuilder var presentation: Presentation { get }
}

extension Never: View {
    public var presentation: Never {
        return fatalError()
    }
}

extension View where Presentation == Never {
    public var presentation: Never {
        return fatalError()
    }
}
