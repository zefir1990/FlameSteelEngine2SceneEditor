import Foundation

public struct EBox {
    public static private(set) var localizationBundle: Bundle = .main

    public static func initialize(localizationBundle: Bundle) {
        self.localizationBundle = localizationBundle
    }
}
