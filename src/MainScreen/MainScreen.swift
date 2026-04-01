import PresentationKit
import ReactiveTech
import SceneControls

struct MainScreen {
    let mainScreenContext = MainScreenContext()

    func show() {
        print("MainScreen show")
        Presentation {
            SceneView(objects: mainScreenContext.objects)
                .preferredSize(.big)
            ObjectsTreeView(objects: mainScreenContext.objects)
                .preferredSize(.small)
            Panel {
                Button {
                    print("Save scene")
                } label: {
                    Text("Save scene")
                }
                Button {
                    print("Load scene")
                } label: {
                    Text("Load scene")
                }
            }
        }
    }
}