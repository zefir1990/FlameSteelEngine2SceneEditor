#if os(Windows)
public struct WindowsViewRenderer: ViewRenderer {
    public func render(_ view: any View) {
        print("\(type(of: self)): Rendering view \(type(of: view))")
    }
}
#endif   