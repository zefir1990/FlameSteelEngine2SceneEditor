#if os(macOS) && !targetEnvironment(macCatalyst)
import PresentationKit
import SwiftUI

@MainActor
public struct SwiftUIBridgeView: SwiftUI.View {
    @ObservedObject var renderer: SwiftUIViewRenderer
    
    public init(renderer: SwiftUIViewRenderer) {
        self.renderer = renderer
    }
    
    public var body: some SwiftUI.View {
        SwiftUI.Group {
            if let rootView = renderer.rootView {
                SwiftUIMapper.map(rootView)
            } else {
                SwiftUI.Text("Rendering Engine View...")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
#endif
