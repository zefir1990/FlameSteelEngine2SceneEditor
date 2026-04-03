import Foundation
import PresentationKit

#if PresentationKitFrontend_UIKit
import UIKit

@main
@MainActor
struct Launcher {
    static func main() {
        print("Hello Launcher.swift (UIKit)")
        UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
    }
}
#else
@main
@MainActor 
struct Launcher {
    static func main() {
        print("Hello Launcher.swift (Non-UIKit)")
        #if PresentationKitFrontend_SwiftUI
        let ioSystem = Factory.swiftuiIOSystem()
        let app = App(ioSystem: ioSystem)
        app.run()
        #else
        let ioSystem = Factory.wxIOSystem()
        let app = App(ioSystem: ioSystem)
        app.run()
        #endif
    }
}
#endif
