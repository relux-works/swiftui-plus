
@dynamicMemberLookup
public struct Numbered<Element> {
    public var number: Int
    public var element: Element
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Element, T>) -> T {
        get { element[keyPath: keyPath] }
        set { element[keyPath: keyPath] = newValue }
    }
}


public extension Sequence {
  func numbered(startingAt start: Int = 1) -> [Numbered<Element>] {
    zip(start..., self)
      .map { Numbered(number: $0.0, element: $0.1) }
  }
}


extension Numbered: Identifiable where Element: Identifiable {
  public var id: Element.ID { element.id }
}
