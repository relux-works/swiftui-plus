import SwiftUI

public extension View {
    func scaleAppearance(
        shown: Binding<Bool>,
        animation: Animation = .easeInOut,
        anchor: Alignment = .center,
        mode: ScaleAppearanceModifier.Mode = .vertical
    ) -> some View {
        self
            .modifier(
                ScaleAppearanceModifier(
                    shown: shown,
                    animation: animation,
                    anchor: anchor,
                    mode: mode
                )
            )
    }
}

extension ScaleAppearanceModifier {
    public enum Mode {
        case vertical
        case horizontal(minWidth: CGFloat = 0)
    }
}

public struct ScaleAppearanceModifier: ViewModifier {
    @State private var frameValue: CGFloat? // animated content size
    @State private var rect: CGRect? // content ideal size rect

    @Binding var shown: Bool
    let animation: Animation
    let anchor: Alignment
    let mode: Mode

    public func body(content: Content) -> some View {
        Color.clear
            .frame(width: contentWidth, height: contentHeight)
            .frame(width: frameWidth, height: frameHeight)
            .overlay(alignment: anchor) {
                content
                    .storingSize(in: $rect)
                    .allowsHitTesting(shown)
            }
            .clipped()
            .animation(animation, value: shown)
            .onAppear { self.frameValue = frameValue(for: shown) }
            .onChange(of: shown, perform: handleAppearanceForFrame)
    }

    private func handleAppearanceForFrame(shown: Bool) {
        withAnimation(animation) {
            self.frameValue = frameValue(for: shown)
        }
    }

    private func frameValue(for shown: Bool) -> CGFloat? {
        switch shown {
            case true: return .none
            case false: switch mode {
                case .vertical: return .zero
                case let .horizontal(minWidth): return minWidth
            }
        }
    }
}

extension ScaleAppearanceModifier {
    private var contentWidth: CGFloat? {
        switch mode {
            case .vertical: .none
            case .horizontal: rect?.width
        }
    }

    private var contentHeight: CGFloat? {
        switch mode {
            case .vertical: rect?.height
            case .horizontal: .none
        }
    }

    private var frameWidth: CGFloat? {
        switch mode {
            case .vertical: .none
            case .horizontal: frameValue
        }
    }

    private var frameHeight: CGFloat? {
        switch mode {
            case .vertical: frameValue
            case .horizontal: .none
        }
    }
}
