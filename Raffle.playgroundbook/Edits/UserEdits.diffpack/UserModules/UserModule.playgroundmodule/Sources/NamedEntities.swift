
public struct NamedEntity: Identifiable {
    public let name: String
    public var id: String { self.name }
    
    public init(_ name: String) {
        self.name = name
    }
}

public typealias Prize = NamedEntity

public typealias Participant = NamedEntity
