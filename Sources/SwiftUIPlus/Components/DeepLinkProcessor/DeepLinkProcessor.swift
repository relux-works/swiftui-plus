import Foundation
import UIKit

public protocol IDeepLinkProcessor {
    func process(url: URL, in parentVC: UIViewController?)
    func validate(url: URL, in parentVC: UIViewController?) -> Bool
}

public struct DeepLinkProcessor: IDeepLinkProcessor {
    let handlers: [IDeepLinkHandler]
    
    public init(handlers: [IDeepLinkHandler]) {
        self.handlers = handlers
    }

    public func process(url: URL, in parentVC: UIViewController?) {
        for handler in handlers {
            guard handler.validate(url: url, in: parentVC) else { return }
            handler.process(url: url, in: parentVC)
        }
    }

    public func validate(url: URL, in parentVC: UIViewController?) -> Bool {
        handlers.contains { $0.validate(url: url, in: parentVC) }
    }
}
