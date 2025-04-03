import Foundation
import UIKit

public protocol IDeepLinkHandler: Sendable {
    func process(url: URL, in parentVC: UIViewController?)
    func validate(url: URL, in parentVC: UIViewController?) -> Bool
}
