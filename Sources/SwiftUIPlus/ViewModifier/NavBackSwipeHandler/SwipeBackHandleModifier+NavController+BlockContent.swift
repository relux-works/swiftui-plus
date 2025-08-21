extension UIViewController {
    private static let contentCoverId = "vc_block_content_cover".hashValue
    private static let lock = NSLock()
    private var id: String { ObjectIdentifier(self).debugDescription }


    func blockContent(dimColor: Color, from: String = #function) {
        Self.lock.withLock {
            if view.viewWithTag(Self.contentCoverId) == .none {
//                print(Date.now.timeWithNanos, "swipe handler: blockContent from \(from), nc: \(id) blockContent")
                view.addSubview(contentCover(color: dimColor))
            }
        }
    }

    func unblockContent(from: String = #function) {
        Self.lock.withLock {
            let cover = view.viewWithTag(Self.contentCoverId)
//            print(Date.now.timeWithNanos, "swipe handler: unblockContent from \(from), shield found \(cover != nil)")
            cover?.removeFromSuperview()
        }
    }

    private func contentCover(color: Color) -> UIControl {
        cover(color: color, tag: Self.contentCoverId, frame: view.bounds)
    }

    private func cover(color: Color, tag: Int, frame: CGRect) -> UIControl {
        let cover = UIControl(frame: frame)
        cover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cover.backgroundColor = UIColor(color)
        cover.isUserInteractionEnabled = true
        cover.tag = tag

        return cover
    }
}

