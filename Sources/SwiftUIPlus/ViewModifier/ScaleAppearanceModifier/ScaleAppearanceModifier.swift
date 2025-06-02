import SwiftUI

public extension View {
    func scaleAppearance(
        shown: Binding<Bool>,
        animation: Animation = .easeInOut,
        anchor: Alignment = .center
    ) -> some View {
        self
            .modifier(
                ScaleAppearanceModifier(
                    shown: shown,
                    animation: animation,
                    anchor: anchor
                )
            )
    }
}

struct ScaleAppearanceModifier: ViewModifier {
    @State private var frameSize: CGSize? // animated content size
    @State private var rect: CGRect? // content ideal size rect

    @Binding var shown: Bool
    let animation: Animation
    let anchor: Alignment

    func body(content: Content) -> some View {
        Color.clear
            .frame(width: .none, height: rect?.height)
            .frame(width: .none, height: frameSize?.height)
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
