import SwiftUI

extension View {
    public var keyboardDismissOverlayHole: some View {
        keyboardDismissOverlayHole()
    }

    public func keyboardDismissOverlayHole(holeShape: any Shape = Rectangle()) -> some View {
        self.modifier(KeyboardDismissOverlayHoleModifier(holeShape: holeShape))
    }
}

struct KeyboardDismissOverlayHoleModifier: ViewModifier {
    @EnvironmentObject private var keyboardObserverState: KeyboardDismissOverlayModifier.LS
    @State private var frameRect: CGRect = .zero
    @State private var id: UUID = UUID()
    let holeShape: any Shape

    func body(content: Content) -> some View {
        content
            .storingSize(in: $frameRect, space: .global)
            .onChange(of: frameRect) { keyboardObserverState.excludingFrames[id] = .init(rect: $0, shape: holeShape) }
            .onAppear { keyboardObserverState.excludingFrames[id] = .init(rect: frameRect, shape: holeShape) }
            .onDisappear { keyboardObserverState.excludingFrames.removeValue(forKey: id) }
    }
}