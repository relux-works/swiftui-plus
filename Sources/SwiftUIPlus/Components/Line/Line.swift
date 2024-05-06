import SwiftUI

public struct Line: Shape {
    public init() { }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height/2))
        return path
    }
}