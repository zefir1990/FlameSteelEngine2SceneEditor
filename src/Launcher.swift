import Foundation
import PresentationKit

#if targetEnvironment(macCatalyst) || os(iOS)
import UIKit

@main
@MainActor
struct Launcher {
    static func main() {
        print("Hello Launcher.swift (Catalyst/iOS)")
        UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
    }
}
#else
@main
@MainActor 
struct Launcher {
    static func main() {
        print("Hello Launcher.swift (Native)")
        let app = App()
        app.run()
    }
}
#endif
