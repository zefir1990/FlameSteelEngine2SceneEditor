import PresentationKit

import WxClientPresentationKit

public enum Factory {
    @MainActor
    public static func ioSystem() -> (any IOSystem) {
        let client = WidgetsClient()
        let interactor = WxInteractor()
        let ioSystem = WxIOSystem(widgetsClient: client, interactor: interactor, mainView: MainScreen())
        return ioSystem
    }
}
