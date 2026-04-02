import Foundation

public struct ViewGroup: View {
    public let views: [any View]
    public init(_ views: [any View]) {
        self.views = views
    }
}
