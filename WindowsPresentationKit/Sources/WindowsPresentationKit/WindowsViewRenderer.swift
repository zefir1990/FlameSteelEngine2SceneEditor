import PresentationKit

public struct WindowsViewRenderer: ViewRenderer {
    public init(parent: (any View)?) {}
    public func render(_ view: any View) {
        print("\(type(of: self)): Rendering view \(type(of: view))")
    }
}
    