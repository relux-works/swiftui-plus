import SwiftUI

public extension AnyTransition {
    static var questionaryHeader: AnyTransition {
        .asymmetric(
            insertion:
                AnyTransition
                    .move(edge: .trailing)
                    .combined(with: .opacity)
                    .combined(with: .scale(scale: 0.8, anchor: .trailing)),
            removal:
                AnyTransition
                    .move(edge: .leading)
                    .combined(with: .opacity)
                    .combined(with: .scale(scale: 0.8, anchor: .leading))
        )
    }
}

public extension AnyTransition {
    static var moveFromBottomWithOpacity: AnyTransition {
        .move(edge: .bottom)
        .combined(with: .opacity)
    }
}


public extension AnyTransition {
    static var blurFade: AnyTransition {
        AnyTransition.modifier(
                active: BlurFadeModifier(isActive: true),
                identity: BlurFadeModifier(isActive: false)
        )
    }
}

struct BlurFadeModifier: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 1.5 : 1) // lagging behind effect
            .blur(radius: isActive ? 8 : 0)
            .opacity(isActive ? 0 : 0.7)
    }
}
