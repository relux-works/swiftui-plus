import SwiftUI

extension View {
    public func showFPS(enabled: Bool = false) -> some View {
        self
            .modifier(FpsMonitorModifier(enabled: enabled))
    }
}

struct FpsMonitorModifier: ViewModifier {
    @StateObject private var ls: LS = .init()

    let enabled: Bool

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing, content: monitor)
    }

    @ViewBuilder
    private func monitor() -> some View {
        indicator
            .presentIf(enabled)
    }


    private var indicator: some View {
        Text("FPS: \(Int(ls.fpsCount).description)")
            .monospacedDigit()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8, corners: .allCorners)
    }
}
