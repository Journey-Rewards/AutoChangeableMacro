import SwiftSyntax

public struct Property: Codable, Hashable, Comparable, Sendable {
    init(
        label: String,
        typeDescription: TypeDescription
    ) {
        self.label = label
        self.typeDescription = typeDescription
    }
    
    public let label: String
    public let typeDescription: TypeDescription
    
    public static func < (lhs: Property, rhs: Property) -> Bool {
        lhs.label < rhs.label
    }
    
    var asSource: String {
        "\(label): \(typeDescription.asSource)"
    }
    
    var asFunctionParamter: FunctionParameterSyntax {
        switch typeDescription {
        case .closure:
            FunctionParameterSyntax(
                firstName: .identifier(label),
                colon: .colonToken(trailingTrivia: .space),
                type: AttributedTypeSyntax(
                    specifiers: [],
                    attributes: AttributeListSyntax {
                        AttributeSyntax(attributeName: IdentifierTypeSyntax(
                            name: "escaping",
                            trailingTrivia: .space
                        ))
                    },
                    baseType: IdentifierTypeSyntax(name: .identifier(typeDescription.asSource))
                )
            )
            
        case let .attributed(typeDescription, _, attributes):
            FunctionParameterSyntax(
                firstName: .identifier(label),
                colon: .colonToken(trailingTrivia: .space),
                type: AttributedTypeSyntax(
                    // It is not possible for a property declaration to have specifiers today.
                    specifiers: [],
                    attributes: AttributeListSyntax {
                        AttributeSyntax(attributeName: IdentifierTypeSyntax(
                            name: "escaping",
                            trailingTrivia: .space
                        ))
                        if let attributes {
                            for attribute in attributes {
                                AttributeSyntax(
                                    attributeName: IdentifierTypeSyntax(name: .identifier(attribute)),
                                    trailingTrivia: .space
                                )
                            }
                        }
                    },
                    baseType: IdentifierTypeSyntax(name: .identifier(typeDescription.asSource))
                )
            )
            
        case .simple,
             .nested,
             .composition,
             .optional,
             .implicitlyUnwrappedOptional,
             .some,
             .any,
             .metatype,
             .array,
             .dictionary,
             .tuple,
             .unknown,
             .void:
            FunctionParameterSyntax(
                firstName: .identifier(label),
                colon: .colonToken(trailingTrivia: .space),
                type: IdentifierTypeSyntax(name: .identifier(typeDescription.asSource))
            )
        }
    }

    var asTupleElement: TupleTypeElementSyntax {
        TupleTypeElementSyntax(
            firstName: .identifier(label),
            colon: .colonToken(),
            type: IdentifierTypeSyntax(name: .identifier(typeDescription.asSource))
        )
    }
    
    var generics: [TypeDescription] {
        switch typeDescription {
        case let .simple(_, generics),
             let .nested(_, _, generics):
            generics
        case .any, .array, .attributed, .closure, .composition, .dictionary, .implicitlyUnwrappedOptional, .metatype, .optional, .some, .tuple, .unknown, .void:
            []
        }
    }
}
