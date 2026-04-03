#if canImport(SwiftUI)
import PresentationKit
import SwiftUI

@MainActor
public class SwiftUIViewRenderer: ObservableObject, ViewRenderer {
    public let ioSystem: any IOSystem
    @Published public var rootView: (any PresentationKit.View)?
    
    public required init(parent: (any PresentationKit.View)?, ioSystem: any IOSystem) {
        self.ioSystem = ioSystem
        self.rootView = parent
    }
    
    public func render(_ view: any PresentationKit.View) {
        self.rootView = view
    }
    
    // ViewVisitor implementation (renderer is its own primary visitor for top-level)
    public func visit(_ button: PresentationKit.Button) {}
    public func visit(_ text: PresentationKit.Text) {}
    public func visit(_ panel: Panel) {}
    public func visit(_ viewGroup: ViewGroup) { render(viewGroup) }
    public func visit(_ modifiedView: ModifiedView) { render(modifiedView) }
    public func visit(_ emptyView: PresentationKit.EmptyView) {}
    public func visit(_ objectsTreeView: ObjectsTreeView) {}
    public func visit(_ view: any PresentationKit.View) { render(view) }
}
#endif
