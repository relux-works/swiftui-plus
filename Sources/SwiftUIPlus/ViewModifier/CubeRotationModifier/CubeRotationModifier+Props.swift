import SwiftUI

extension CubeRotationModifier {
    public struct Props {
        public let perspective: CGFloat
        public let rotationDegree: CGFloat
        public init(
            perspective: CGFloat,
            rotationDegree: CGFloat
        ) {
            self.perspective = perspective
            self.rotationDegree = rotationDegree
        }
    }
}

extension CubeRotationModifier.Props {
    public static let defaultValue: Self = .init(perspective: 2.5, rotationDegree: 25.0)
}
