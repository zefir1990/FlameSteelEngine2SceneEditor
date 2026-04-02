import PresentationKit

#if os(Linux)
public struct LinuxViewRenderer: ViewRenderer {
    public init() {}
    public func render(_ view: any View) {
        print("\(type(of: self)): Rendering view \(type(of: view))")
    }
}
#endif
