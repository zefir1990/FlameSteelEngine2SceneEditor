import Foundation
import PresentationKit
import ReactiveTech
import SceneControls
import EBox

@UUIDId
struct MainScreen: View {
    private let mainScreenContext = MainScreenContext()

    var presentation: some View {
        SceneView(objects: mainScreenContext.objects)
            .preferredSize(.big)
        ObjectsTreeView(objects: mainScreenContext.objects)
            .preferredSize(.small)
        Panel {
            Button({
                debugPrint("!!! Save scene action !!!")
                NSLog("!!! Save scene action !!!")
            }) {
                Text(_L("save_scene"))
            }
            Button({
                debugPrint("!!! Load scene action !!!")
                NSLog("!!! Load scene action !!!")
            }) {
                Text(_L("load_scene"))
            }
        }
        .preferredSize(.small)
    }

    func accept(_ visitor: any ViewVisitor) {
        visitor.visit(self)
    }
}