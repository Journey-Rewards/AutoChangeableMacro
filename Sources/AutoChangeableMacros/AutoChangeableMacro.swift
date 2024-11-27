import SwiftSyntax
import SwiftSyntaxMacros

public struct AutoChangeableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration.is(StructDeclSyntax.self) else {
            throw AutoChangeableDiagnostic.onlyApplicableToStruct
        }
        
        let variables = declaration.memberBlock.members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
        let bindings = variables.flatMap(\.bindings).filter { accessorIsAllowed($0.accessorBlock?.accessors) }
        
        let properties: [Property] = bindings.compactMap { binding in
            guard
                let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                let type = binding.typeAnnotation?.type
            else {
                return nil
            }
            
            return Property(
                label: identifier,
                typeDescription: type.typeDescription
            )
        }
        
        let hasMainActor = declaration.attributes.contains { attribute in
            attribute.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "MainActor"
        }
        
        return [
            initializer(properties: properties),
            changeableInitializer(properties: properties, hasMainActor: hasMainActor)
        ].compactMap { $0 }
    }
    
    private static func initializer(properties: [Property]) -> DeclSyntax? {
        let initializerArguments: [String] = properties.map {
            let typeDescription = $0.typeDescription
            switch typeDescription {
            case .closure where typeDescription.isOptional:
                return "    \($0.asSource)"
                
            case .closure:
                return "    \($0.label): @escaping \($0.typeDescription.asSource)"
                
            case .attributed(let typeDescription,_ ,_) where typeDescription.isClosure:
                return "    \($0.label): @escaping \($0.typeDescription.asSource)"
                
            default:
                return "    \($0.asSource)"
            }
            
        }
        
        let initializerBody: [String] = properties.map {
            return "    self.\($0.label) = \($0.label)"
        }
        
        return DeclSyntax("""
        init(
        \(raw: initializerArguments.joined(separator: ",\n")),
        changeable: Void? = nil
        ) {
        \(raw: initializerBody.joined(separator: "\n"))
        }
        """)
    }
    
    private static func changeableInitializer(properties: [Property], hasMainActor: Bool) -> DeclSyntax? {        
        let initializerBody: [String] = properties.map {
            return "    self.\($0.label) = copy.\($0.label)"
        }
        
        return DeclSyntax("""
        \(raw: hasMainActor ? "nonisolated" : "") init(copy: ChangeableWrapper<Self>) {
        \(raw: initializerBody.joined(separator: "\n"))
        }
        """)
    }
    
    private static func accessorIsAllowed(_ accessor: AccessorBlockSyntax.Accessors?) -> Bool {
        guard let accessor else { return true }
        return switch accessor {
        case .accessors(let accessorDeclListSyntax):
            !accessorDeclListSyntax.contains {
                $0.accessorSpecifier.text == "get" || $0.accessorSpecifier.text == "set"
            }
        case .getter:
            false
        @unknown default:
            false
        }
    }
}
