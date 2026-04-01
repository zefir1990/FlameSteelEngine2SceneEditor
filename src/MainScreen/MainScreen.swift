struct MainScreen {
    func show() {
        print("MainScreen show")

        let mainScreenContext = MainScreenContext()

        Presentation {
            SceneView()
                .preferredSize(.big)
            ObjectsTreeView()
                .preferredSize(.small)
        }
        .bind(to: mainScreenContext)
    }
}