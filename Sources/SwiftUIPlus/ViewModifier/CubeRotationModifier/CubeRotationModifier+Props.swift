import SwiftUI

extension CubeRotationModifier {
    public struct Props {
        public let perspective: CGFloat
        public let rotationDegree: CGFloat
        public let ignoreSafeAreaEdges: Edge.Set?
        public init(
            perspective: CGFloat,
            rotationDegree: CGFloat,
            ignoreSafeAreaEdges: Edge.Set?
        ) {
            self.perspective = perspective
            self.rotationDegree = rotationDegree
            self.ignoreSafeAreaEdges = ignoreSafeAreaEdges
        }
    }
}

extension CubeRotationModifier.Props: Sendable { }

extension CubeRotationModifier.Props {
    public nonisolated static let defaultValue: Self = .init(
        perspective: 2.5,
        rotationDegree: 25.0,
        ignoreSafeAreaEdges: .all
    )
}
