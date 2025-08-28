import Foundation
import UIKit

public protocol IDeepLinkProcessor: Sendable {
    func process(url: URL)
    func validate(url: URL) -> Bool
}

public struct DeepLinkProcessor: IDeepLinkProcessor {
    let handlers: [IDeepLinkHandler]
    
    public init(handlers: [IDeepLinkHandler]) {
        self.handlers = handlers
    }

    public func process(url: URL) {
        handlers
            .first { $0.validate(url: url) }?
            .process(url: url)
    }

    public func validate(url: URL) -> Bool {
        handlers.contains { $0.validate(url: url) }
    }
}
