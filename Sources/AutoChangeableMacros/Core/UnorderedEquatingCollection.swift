public struct UnorderedEquatingCollection<Element: Hashable>: Hashable, Collection, ExpressibleByArrayLiteral {
    public var startIndex: Int { array.startIndex }
    public var endIndex: Int { array.endIndex }
    
    private let array: [Element]
    private let set: Set<Element>
    
    public init(_ array: [Element]) {
        self.array = array
        set = Set(array)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.set == rhs.set
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(set)
    }
    
    public func makeIterator() -> IndexingIterator<[Element]> {
        array.makeIterator()
    }
    
    public func index(after i: Int) -> Int {
        array.index(after: i)
    }

    public subscript(position: Int) -> Element {
        array[position]
    }

    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    public typealias ArrayLiteralElement = Element
}

extension UnorderedEquatingCollection: Encodable where Element: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(array)
    }
}

extension UnorderedEquatingCollection: Decodable where Element: Decodable {
    public init(from decoder: Decoder) throws {
        try self.init(decoder.singleValueContainer().decode([Element].self))
    }
}

extension UnorderedEquatingCollection: Sendable where Element: Sendable { }
