import Foundation
import PresentationKit
import ReactiveTech
import SceneControls

struct MainScreen: Screen {
    let mainScreenContext = MainScreenContext()

    func show() -> Presentation {
        Presentation {
            SceneView(objects: mainScreenContext.objects)
                .preferredSize(.big)
            ObjectsTreeView(objects: mainScreenContext.objects)
                .preferredSize(.small)
            Panel {
                Button {
                    print("Save scene action")
                } label: {
                    Text(_L("save_scene"))
                }
                Button {
                    print("Load scene action")
                } label: {
                    Text(_L("load_scene"))
                }
            }
            .preferredSize(.small)
        }
    }
}