#if canImport(UIKit)
import UIKit
import PresentationKit

@MainActor
internal class ActionWrapper {
    private let action: () -> Void
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    @objc func invoke() {
        action()
    }
}

@MainActor
public class UIKitMapper: ViewVisitor {
    public var result: UIView = UIView()
    private static var actionWrappers: [UIButton: ActionWrapper] = [:]
    
    public init() {}
    
    public static func map(_ view: any PresentationKit.View) -> UIView {
        let mapper = UIKitMapper()
        view.accept(mapper)
        return mapper.result
    }
    
    public func visit(_ button: PresentationKit.Button) {
        let uiButton = UIButton(type: .system)
        let labelMapper = UIKitMapper()
        button.label.accept(labelMapper)
        let label = (labelMapper.result as? UILabel)?.text ?? "Button"
        uiButton.setTitle(label, for: .normal)
        
        let wrapper = ActionWrapper(button.action)
        uiButton.addTarget(wrapper, action: #selector(ActionWrapper.invoke), for: .touchUpInside)
        Self.actionWrappers[uiButton] = wrapper
        
        result = uiButton
    }
    
    public func visit(_ text: PresentationKit.Text) {
        let label = UILabel()
        label.text = text.content
        label.textAlignment = .center
        result = label
    }
    
    public func visit(_ panel: PresentationKit.Panel) {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        for child in panel.children {
            stack.addArrangedSubview(UIKitMapper.map(child))
        }
        result = stack
    }
    
    public func visit(_ viewGroup: PresentationKit.ViewGroup) {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        for view in viewGroup.views {
            stack.addArrangedSubview(UIKitMapper.map(view))
        }
        result = stack
    }
    
    public func visit(_ modifiedView: PresentationKit.ModifiedView) {
        result = UIKitMapper.map(modifiedView._content)
    }
    
    public func visit(_ emptyView: PresentationKit.EmptyView) {
        result = UIView()
    }
    
    public func visit(_ objectsTreeView: PresentationKit.ObjectsTreeView) {
        let label = UILabel()
        label.text = "[Objects Tree Placeholder]"
        result = label
    }
    
    public func visit(_ view: any PresentationKit.View) {
        result = UIKitMapper.map(view.subviews)
    }
}
#endif
