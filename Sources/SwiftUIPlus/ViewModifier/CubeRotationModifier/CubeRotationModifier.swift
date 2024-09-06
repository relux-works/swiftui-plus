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
        content
            .rotation3DEffect(
                .init(degrees: self.calcAngle(rect: rect, rotationDegree: props.rotationDegree)),
                axis: (x: 0, y: 1, z: 0),
                anchor: rect.minX > 0 ? .leading : .trailing,
                perspective: props.perspective
            )
            .transaction { $0.animation = .none }
            .ignoresSafeArea(edges: props.ignoreSafeAreaEdges)
            .background {
                GeometryReader { gr in
                    Color.clear
                        .ignoresSafeArea(edges: props.ignoreSafeAreaEdges)
                        .onChange(of: gr.frame(in: .global)) { self.rect = $0 }
                }
            }
    }

    private func calcAngle(rect: CGRect, rotationDegree: CGFloat) -> Double {
        let tempAngle = (rect.minX / (0.5 * bounds.width)).truncatingRemainder(dividingBy: 2)
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
