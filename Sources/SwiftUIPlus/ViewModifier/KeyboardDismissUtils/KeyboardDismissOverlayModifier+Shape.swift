import SwiftUI

extension KeyboardDismissOverlayModifier.OverlayShape {
    struct HoleShape {
        let rect: CGRect
        let shape: any Shape
    }
}

extension KeyboardDismissOverlayModifier {
    struct OverlayShape: View {
        @Environment(\.bounds) private var bounds
        @Binding var holes : [HoleShape]

        var body: some View {
            rectangleShapeMask(in: bounds, holes: holes)
                .fill(style: FillStyle(eoFill: true))
                .ignoresSafeArea()
        }

        private func rectangleShapeMask(in rect: CGRect, holes: [HoleShape]) -> Path {
            var shape = Rectangle().path(in: rect)
            holes
                .forEach { shape.addPath($0.shape.path(in: $0.rect)) }
            return shape
        }
    }
}