import SwiftUI

public struct FollowPathEffect: GeometryEffect {
    private var progress: CGFloat
    private let path: Path
    private var rotate: Bool

    public init(
            progress: CGFloat = 0,
            path: Path,
            rotate: Bool = true
    ) {
        self.progress = progress
        self.path = path
        self.rotate = rotate
    }

    public var animatableData: CGFloat {
        get { return progress }
        set { progress = newValue }
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        if !rotate { // Skip rotation login
            let pt = percentPoint(progress)

            return ProjectionTransform(CGAffineTransform(translationX: pt.x, y: pt.y))
        } else {
            let pt1 = percentPoint(progress)
            let pt2 = percentPoint(progress - 0.01)

            let angle = calculateDirection(pt1, pt2)
            let transform = CGAffineTransform(translationX: pt1.x, y: pt1.y).rotated(by: angle)

            return ProjectionTransform(transform)
        }
    }

    private func percentPoint(_ percent: CGFloat) -> CGPoint {
        // percent difference between points
        let diff: CGFloat = 0.001
        let comp: CGFloat = 1 - diff

        // handle limits
        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)

        let f = pct > comp ? comp : pct
        let t = pct > comp ? 1 : pct + diff
        let tp = path.trimmedPath(from: f, to: t)

        return CGPoint(x: tp.boundingRect.midX, y: tp.boundingRect.midY)
    }

    private func calculateDirection(_ pt1: CGPoint,_ pt2: CGPoint) -> CGFloat {
        let a = pt2.x - pt1.x
        let b = pt2.y - pt1.y

        let angle = a < 0 ? atan(Double(b / a)) : atan(Double(b / a)) - Double.pi

        return CGFloat(angle)
    }
}