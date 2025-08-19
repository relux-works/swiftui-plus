extension UINavigationController {
    private static let shieldId = "nc_block_content_cover".hashValue
    private static let lock = NSLock()
    private var id: String { ObjectIdentifier(self).debugDescription }

    func blockContent(dim: CGFloat = 0, from: String = #function) {
        Self.lock.withLock {
            guard view.viewWithTag(Self.shieldId) == .none else { return }

            let shield = UIControl(frame: view.bounds)
            shield.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            shield.backgroundColor = UIColor.gray.withAlphaComponent(dim)
            shield.isUserInteractionEnabled = true
            shield.tag = Self.shieldId
            print(Date.now.timeWithNanos, "swipe handler: blockContent from \(from), nc: \(id) blockContent")

            view.addSubview(shield)
        }
    }

    func unblockContent(from: String = #function) {
        Self.lock.withLock {
            let shield = view.viewWithTag(Self.shieldId)
            print(Date.now.timeWithNanos, "swipe handler: unblockContent from \(from), shield found \(shield != nil)")

            shield?.removeFromSuperview()
        }
    }
}
