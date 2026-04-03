#if canImport(SwiftUI)
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                SwiftUI.Text("No Views to Render")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        #if canImport(UIKit)
        .background(SwiftUI.Color(UIColor.systemBackground))
        #endif
        .onAppear {
            print("SwiftUIBridgeView onAppear")
        }
    }
}
#endif
