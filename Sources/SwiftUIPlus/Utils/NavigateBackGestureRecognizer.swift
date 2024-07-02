import SwiftUI

/*
 SwiftUI navigate back doesnt work when BACK button is hidden
 This extension allows NavController handle swipe back gesture and pop current viewController
 */
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}