import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
public struct PresentationKitPlugin: CompilerPlugin {
    public let providingMacros: [Macro.Type] = [
        UUIDIdMacro.self
    ]

    public init() {}
}
