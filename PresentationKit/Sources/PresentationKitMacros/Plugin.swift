import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct PresentationKitPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        UUIDIdMacro.self
    ]
}
