import SwiftUI

extension KeyboardDismissOverlayModifier {
    @MainActor
    class LS: ObservableObject {
        @Published var excludingFrames: [UUID: OverlayShape.HoleShape] = [:]
        @Published var frames: [OverlayShape.HoleShape] = []

        init() {
            $excludingFrames
                .map {$0.map{$0.value}}
                .assign (to: &$frames)
        }
    }
}
