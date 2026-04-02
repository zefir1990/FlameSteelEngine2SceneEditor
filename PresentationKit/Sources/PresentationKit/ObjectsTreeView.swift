import Foundation
import ReactiveTech

@UUIDId
public struct ObjectsTreeView: View {
    public let objects: Binding<[Any]>
    
    public init(objects: Binding<[Any]>) {
        self.objects = objects
    }

    public func accept(_ visitor: any ViewVisitor) {
        visitor.visit(self)
    }
}
