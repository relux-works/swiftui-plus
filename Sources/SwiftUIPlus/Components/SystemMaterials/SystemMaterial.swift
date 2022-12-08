import SwiftUI

public struct SystemMaterial: View {
    private let style: UIBlurEffect.Style

    public init(_ style: UIBlurEffect.Style) {
        self.style = style
    }

    public var body: some View {
        Material(style: style)
    }
}


extension SystemMaterial {
    struct Material: UIViewRepresentable {
        var style: UIBlurEffect.Style

        func makeUIView(context: Context) -> UIVisualEffectView {
            UIVisualEffectView(effect: UIBlurEffect(style: style))
        }

        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
            uiView.effect = UIBlurEffect(style: style)
        }
    }

}


