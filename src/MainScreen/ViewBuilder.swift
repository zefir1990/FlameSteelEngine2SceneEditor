@resultBuilder
struct ViewBuilder {
    static func buildBlock(_ components: View...) -> [View] {
        return components
    }
}
