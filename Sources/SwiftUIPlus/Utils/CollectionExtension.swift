import SwiftUI

public extension Collection where Element: Identifiable {
    
    func firstIndex(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
    
    
    /// Tells wether collection contains the element basef on its stable identinty.
    func contains(matching element: Element) -> Bool {
        self.contains(where: { $0.id == element.id })
    }
}
