import Foundation
import UIKit

public protocol IDeepLinkHandler: Sendable {
    func process(url: URL)
    func validate(url: URL) -> Bool
}
