#if canImport(SwiftUI)
import PresentationKit
import SwiftUI

@MainActor
public class SwiftUIMapper: ViewVisitor {
    private var result: SwiftUI.AnyView = SwiftUI.AnyView(SwiftUI.EmptyView())
    
    public init() {}
    
    public static func map(_ view: any PresentationKit.View) -> SwiftUI.AnyView {
        let mapper = SwiftUIMapper()
        view.accept(mapper)
        return mapper.result
    }

    public func visit(_ button: PresentationKit.Button) {
        let labelView = SwiftUIMapper.map(button.label)
        result = SwiftUI.AnyView(
            SwiftUI.Button(action: {
                button.action()
            }) {
                labelView
            }
        )
    }

    public func visit(_ text: PresentationKit.Text) {
        result = SwiftUI.AnyView(SwiftUI.Text(text.content))
    }

    public func visit(_ panel: Panel) {
        result = SwiftUI.AnyView(
            SwiftUI.HStack {
                SwiftUI.ForEach(0..<panel.children.count, id: \.self) { index in
                    SwiftUIMapper.map(panel.children[index])
                }
            }
        )
    }

    public func visit(_ viewGroup: ViewGroup) {
        result = SwiftUI.AnyView(
            SwiftUI.VStack {
                SwiftUI.ForEach(0..<viewGroup.views.count, id: \.self) { index in
                    SwiftUIMapper.map(viewGroup.views[index])
                }
            }
        )
    }

    public func visit(_ modifiedView: ModifiedView) {
        result = SwiftUIMapper.map(modifiedView._content)
    }

    public func visit(_ emptyView: PresentationKit.EmptyView) {
        result = SwiftUI.AnyView(SwiftUI.EmptyView())
    }

    public func visit(_ objectsTreeView: ObjectsTreeView) {
        result = SwiftUI.AnyView(
            SwiftUI.List {
                SwiftUI.Text("[Objects Tree Placeholder]")
                SwiftUIMapper.map(objectsTreeView.subviews)
            }
        )
    }

    public func visit(_ view: any PresentationKit.View) {
        result = SwiftUIMapper.map(view.subviews)
    }
}
#endif
