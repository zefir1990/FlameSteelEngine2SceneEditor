import SwiftSyntax
import SwiftSyntaxMacros
import SwiftCompilerPlugin
import SwiftSyntaxBuilder

public struct UUIDIdMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return [
            "public let id: Foundation.UUID = Foundation.UUID()"
        ]
    }
}
