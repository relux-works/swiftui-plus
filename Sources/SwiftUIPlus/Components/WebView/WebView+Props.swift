import Foundation

public extension WebView {
    struct Props {
        public let request: URLRequest

        public init(
            request: URLRequest
        ) {
            self.request = request
        }
    }
}
