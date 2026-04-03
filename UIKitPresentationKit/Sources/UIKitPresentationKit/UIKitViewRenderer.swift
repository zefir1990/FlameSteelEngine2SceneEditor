#if canImport(UIKit)
import UIKit
import PresentationKit

@MainActor
public class UIKitViewRenderer: ViewRenderer {
    public let ioSystem: any IOSystem
    public var rootViewController: UIViewController?

    public required init(parent: (any PresentationKit.View)?, ioSystem: any IOSystem) {
        self.ioSystem = ioSystem
    }

    public func render(_ view: any PresentationKit.View) {
        let uiView = UIKitMapper.map(view)
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        uiView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(uiView)
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor),
            uiView.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor),
            uiView.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        self.rootViewController = vc
    }

    public func visit(_ button: PresentationKit.Button) {}
    public func visit(_ text: PresentationKit.Text) {}
    public func visit(_ panel: PresentationKit.Panel) {}
    public func visit(_ viewGroup: PresentationKit.ViewGroup) {}
    public func visit(_ modifiedView: PresentationKit.ModifiedView) {}
    public func visit(_ emptyView: PresentationKit.EmptyView) {}
    public func visit(_ objectsTreeView: ObjectsTreeView) {}
    public func visit(_ view: any PresentationKit.View) {}
}
#endif
