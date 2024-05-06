import SwiftUI
import UIKit

public extension View {
    func blurred(radius: CGFloat, spread: CGPoint = .zero) -> some View {
        self
            .overlay(
                BackdropBlurView(radius: radius)
                    .padding(.horizontal, -spread.x)
                    .padding(.vertical, -spread.y)
            )
    }
}

struct BackdropBlurView: View {
    let radius: CGFloat

    @ViewBuilder
    var body: some View {
        BackdropView().blur(radius: radius)
    }
}

struct BackdropView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect()
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {

    }
}
