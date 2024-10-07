import SwiftDiagnostics

enum AutoChangeableDiagnostic: String, DiagnosticMessage, Error {
    case onlyApplicableToStruct
    
    var message: String {
        switch self {
        case .onlyApplicableToStruct:
            "`@Changeable` can only be applied to `struct`"
        }
    }
    
    var diagnosticID: MessageID {
        MessageID(domain: "ChangeableMacro", id: rawValue)
    }
    
    var severity: DiagnosticSeverity {
        switch self {
        case .onlyApplicableToStruct: .error
        }
    }
}
