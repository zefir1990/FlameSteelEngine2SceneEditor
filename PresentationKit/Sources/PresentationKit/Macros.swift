import Foundation

@attached(member, names: named(id))
public macro UUIDId() = #externalMacro(module: "PresentationKitMacros", type: "UUIDIdMacro")
