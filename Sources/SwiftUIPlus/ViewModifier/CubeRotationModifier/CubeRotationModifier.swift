import SwiftUI
import Combine

extension View {
    public var modifyWithCubeRotation: some View {
        self.modifier(CubeRotationModifier())
    }

    public func modifyWithCubeRotation(props: CubeRotationModifier.Props) -> some View {
        self.modifier(CubeRotationModifier(props: props))
    }
}



public struct CubeRotationModifier: ViewModifier {
    @Environment(\.bounds) private var bounds
    private let props: Props

    public init(
        props: Props = .defaultValue
    ) {
        self.props = props
    }

    @State private var rect: CGRect = .zero

    public func body(content: Content) -> some View {
        ZStack {
            Color.clear
                .storingSize(in: $rect, space: .global)
            content
                .rotation3DEffect(
                    .init(degrees: self.calcAngle(rect: rect, rotationDegree: props.rotationDegree)),
                    axis: (x: 0, y: 1, z: 0),
                    anchor: rect.minX > 0 ? .leading : .trailing,
                    perspective: props.perspective
                )
                .ignoresSafeArea(edges: props.ignoreSafeAreaEdges)
        }
    }

    private func calcAngle(rect: CGRect, rotationDegree: CGFloat) -> Double {
        let tempAngle = rect.minX / (0.5 * bounds.width)
        return tempAngle * rotationDegree
    }
}

fileprivate extension View {
    @ViewBuilder
    func ignoresSafeArea(edges: Edge.Set?) -> some View {
        switch edges {
            case .none: self
            case let .some(edges): self.ignoresSafeArea(edges: edges)
        }
    }
}
