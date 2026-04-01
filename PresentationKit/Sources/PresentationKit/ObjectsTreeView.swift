import ReactiveTech

public struct ObjectsTreeView: View {
    public let objects: Binding<[Any]>
    
    public init(objects: Binding<[Any]>) {
        self.objects = objects
    }
}
