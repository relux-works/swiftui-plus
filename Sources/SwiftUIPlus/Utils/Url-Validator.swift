import Foundation
import UIKit

public extension String {
    @MainActor
    var isUrl: Bool {
        guard let url = URL(string: self) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
}