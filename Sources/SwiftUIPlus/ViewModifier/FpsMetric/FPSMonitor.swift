import SwiftUI

extension View {
    public func fpsMetric(
        enabled: Bool = true,
        minTimeInterval: TimeInterval = 1.5
    ) -> some View {
        self
            .modifier(
                FpsMonitorModifier(
                    props: .init(enabled: enabled, minTimeInterval: minTimeInterval)
                )
            )
    }
}

extension FpsMonitorModifier {
    struct Props {
        let enabled: Bool
        let minTimeInterval: TimeInterval
    }
}
struct FpsMonitorModifier: ViewModifier {
    @StateObject private var ls: LS

    private let props: Props

    init(
        props: Props
    ) {
        self.props = props
        self._ls = .init(wrappedValue: .init(props: props))
    }

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing, content: monitor)
    }

    @ViewBuilder
    private func monitor() -> some View {
        indicator
            .presentIf(props.enabled)
    }


    private var indicator: some View {
        Text("FPS: \(Int(ls.fpsCount).description)")
            .monospacedDigit()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(indicatorBg)
            .cornerRadius(8, corners: .allCorners)
    }

    private var indicatorBg: some View {
        ls.highlight.associatedColor.opacity(0.3)
    }
}
