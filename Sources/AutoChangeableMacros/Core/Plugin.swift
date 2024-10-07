import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

@main
struct AutoChangeablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoChangeableMacro.self,
    ]
}
