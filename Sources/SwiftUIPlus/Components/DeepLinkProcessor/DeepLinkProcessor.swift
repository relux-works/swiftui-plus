import Foundation
import UIKit

public protocol IDeepLinkProcessor {
    func process(url: URL, in parentVC: UIViewController?)
}

public struct DeepLinkProcessor: IDeepLinkProcessor {
    let handlers: [IDeepLinkHandler]
    
    public init(handlers: [IDeepLinkHandler]) {
        self.handlers = handlers
    }

    public func process(url: URL, in parentVC: UIViewController?) {
        let _ = handlers
            .contains { $0.process(url: url, in: parentVC) }
    }
}