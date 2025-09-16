import SwiftUI

public extension View {
    func scaleAppearance(
        shown: Binding<Bool>,
        animation: Animation = .easeInOut,
        anchor: Alignment = .center,
        mode: ScaleAppearanceModifierMode = .vertical
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

public enum ScaleAppearanceModifierMode {
    case vertical
    case horizontal
}

struct ScaleAppearanceModifier: ViewModifier {
    @State private var frameSize: CGSize? // animated content size
    @State private var rect: CGRect? // content ideal size rect

    @Binding var shown: Bool
    let animation: Animation
    let anchor: Alignment
    let mode: ScaleAppearanceModifierMode

    func body(content: Content) -> some View {
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
            .onAppear { self.frameSize = frameSize(for: shown) }
            .onChange(of: shown, perform: handleAppearanceForFrame)
    }

    private func handleAppearanceForFrame(shown: Bool) {
        withAnimation(animation) {
            self.frameSize = frameSize(for: shown)
        }
    }

    private func frameSize(for shown: Bool) -> CGSize? {
        switch shown {
            case true: .none
            case false: .zero
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
            case .horizontal: frameSize?.width
        }
    }

    private var frameHeight: CGFloat? {
        switch mode {
            case .vertical: frameSize?.height
            case .horizontal: .none
        }
    }
}
