import PresentationKit
import ReactiveTech

struct MainScreen {
    let mainScreenContext = MainScreenContext()

    func show() {
        print("MainScreen show")
        Presentation {
            SceneView(objects: mainScreenContext.objects)
                .preferredSize(.big)
            ObjectsTreeView(objects: mainScreenContext.objects)
                .preferredSize(.small)
        }
    }
}