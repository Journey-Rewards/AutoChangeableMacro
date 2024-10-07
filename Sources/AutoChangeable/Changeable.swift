import Foundation

public protocol Changeable {
    associatedtype ChangeableCopy
    var changeableCopy: ChangeableCopy { get }

    init(copy: ChangeableCopy)
}

extension Changeable where ChangeableCopy == Self {
    public var changeableCopy: ChangeableCopy { self }
    
    public init(copy: ChangeableCopy) {
        self = copy
    }
}

extension Changeable {
    public func changing(_ change: (inout ChangeableCopy) -> Void) -> Self {
        var copy = changeableCopy
        change(&copy)
        return Self(copy: copy)
    }
    
    public mutating func change(_ change: (inout ChangeableCopy) -> Void) {
        var copy = changeableCopy
        change(&copy)
        self = Self(copy: copy)
    }
}

/// Used for backward compatibility
public protocol AutoChangeable: Changeable { }
