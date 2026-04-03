#if canImport(SwiftUI)
import PresentationKit
import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@MainActor
public class SwiftUIIOSystem: IOSystem {
    private let mainView: any PresentationKit.View
    private let renderer: SwiftUIViewRenderer
    #if canImport(UIKit)
    private var window: UIWindow?
    #endif
    
    public init(mainView: any PresentationKit.View) {
        self.mainView = mainView
        // Create a temporary renderer to satisfy initialization, then overwrite its ioSystem reference if needed.
        self.renderer = SwiftUIViewRenderer(parent: mainView, ioSystem: DefaultIOSystem(mainView: mainView))
    }
    
    public func viewRenderer(parent: (any PresentationKit.View)?) -> any ViewRenderer {
        return renderer
    }
    
    public func handle(event: ApplicationEvent) {
        switch event {
        case .applicationCalled:
            startSwiftUI()
        }
    }
    
    public func shutdown() {
        #if canImport(AppKit)
        NSApp.terminate(nil)
        #elseif canImport(UIKit)
        print("SwiftUIIOSystem: Shutdown requested on UIKit platform.")
        #endif
    }
    
    private func startSwiftUI() {
        #if canImport(AppKit)
        let app = NSApplication.shared
        app.setActivationPolicy(.regular)
        
        // Setup a basic menu bar so the app doesn't feel "stuck"
        setupMenu()
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1024, height: 768),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Flame Steel Engine 2 - Native macOS (SwiftUI)"
        window.contentView = NSHostingView(rootView: SwiftUIBridgeView(renderer: renderer))
        window.makeKeyAndOrderFront(nil)
        
        app.activate(ignoringOtherApps: true)
        app.run()
        #elseif canImport(UIKit)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .systemBackground
        renderer.render(mainView)
        window.rootViewController = UIHostingController(rootView: SwiftUIBridgeView(renderer: renderer))
        window.makeKeyAndVisible()
        self.window = window
        #endif
    }

    #if canImport(AppKit)
    private func setupMenu() {
        let mainMenu = NSMenu()
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu()
        let quitMenuItem = NSMenuItem(title: "Quit Flame Steel Engine 2", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appMenu.addItem(quitMenuItem)
        appMenuItem.submenu = appMenu
        NSApplication.shared.mainMenu = mainMenu
    }
    #endif
}
#endif
