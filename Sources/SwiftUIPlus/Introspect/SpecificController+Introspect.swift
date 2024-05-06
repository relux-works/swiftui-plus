import UIKit

public extension UIViewController {
    func findSpecificChildVC<C:UIViewController>() -> C? {
        var vc: UIViewController? = self
        while let current = vc {
            guard let vc = vc as? C else {
                vc = current.parent
                continue
            }
            return vc
        }
        return nil
    }
}