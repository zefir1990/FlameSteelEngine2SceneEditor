import PresentationKit
import ReactiveTech

public struct SceneView: View {
    public let objects: Binding<[Any]>
    
    public init(objects: Binding<[Any]>) {
        self.objects = objects
    }

    public func accept(_ visitor: any ViewVisitor) {
        visitor.visit(self)
    }
}
