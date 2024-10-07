import AutoChangeable

@MainActor
@AutoChangeable
struct Model: AutoChangeable {
    let stringValue: String
    let optionalStringValue: String?
    let integerValue: Int
    let onTap: @MainActor () -> Void
}
