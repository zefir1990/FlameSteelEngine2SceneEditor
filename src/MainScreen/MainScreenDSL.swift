protocol View {}

struct MainScreenContext {
    init() {}
}

enum Size {
    case big
    case small
}

struct SceneView: View {
    init() {}
}

struct ObjectsTreeView: View {
    init() {}
}

struct ModifiedView: View {
    let _content: View
    let size: Size
}

extension View {
    func preferredSize(_ size: Size) -> View {
        return ModifiedView(_content: self, size: size)
    }
}

@resultBuilder
struct ViewBuilder {
    static func buildBlock(_ components: View...) -> [View] {
        return components
    }
}

struct Presentation {
    let views: [View]
    
    init(@ViewBuilder _ content: () -> [View]) {
        self.views = content()
    }
    
    func bind(to context: MainScreenContext) {
        print("Binding presentation to context")
    }
}
