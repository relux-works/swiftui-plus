import Foundation

extension URL {
    @resultBuilder
    public struct OpenUrlReactionBuilder {
        public static func buildBlock() -> [OpenUrlPatternReaction] { [] }

        public static func buildBlock(_ actions: OpenUrlPatternReaction...) -> [OpenUrlPatternReaction] {
            actions
        }
    }
}
