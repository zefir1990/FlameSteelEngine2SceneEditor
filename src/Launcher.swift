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
        let app = App()
        #if PresentationKitFrontend_SwiftUI
        let ioSystem = Factory.swiftuiIOSystem()
        app.run(ioSystem: ioSystem)
        #else
        let ioSystem = Factory.wxIOSystem()
        app.run(ioSystem: ioSystem)
        #endif
    }
}
#endif
