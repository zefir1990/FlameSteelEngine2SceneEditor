import Foundation
import PresentationKit
import ReactiveTech
import SceneControls
import EBox

struct MainScreen: View {
    private let mainScreenContext = MainScreenContext()

    var presentation: some View {
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