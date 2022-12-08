import SwiftUI

extension DatedLineChart {
    struct ChartPath: Shape {
        let points: [Point]
        var progress: CGFloat
        let style: Style
        let rangeX: ClosedRange<Date>
        let rangeY: ClosedRange<Double>

        var animatableData: CGFloat{
            get{ progress }
            set{ progress = newValue }
        }

        func path(in rect: CGRect) -> Path {
            let points = Self.points(points: points, rect: rect, rangeX: rangeX, rangeY: rangeY)
            switch style {
            case .line:
                return Self.createLinePath(for: points, rect: rect, closePath: false)
                        .trimmedPath(from: 0, to: progress)
            case .curved:
                return Self.createQuadCurvePath(for: points, rect: rect, closePath: false)
                        .trimmedPath(from: 0, to: progress)
            }
        }

        static func points(points: [Point], rect: CGRect, rangeX: ClosedRange<Date>, rangeY: ClosedRange<Double>) -> [CGPoint] {
            let width = rect.size.width
            let height = rect.size.height

            let spreadX = rangeX.upperBound.timeIntervalSince(rangeX.lowerBound)
            let minPointX = rangeX.lowerBound

            let spreadY = rangeY.upperBound - rangeY.lowerBound
            let minPointY = rangeY.lowerBound

            let points = points.enumerated().compactMap { item -> CGPoint in
                let relativeOffsetX = (item.element.timestamp.timeIntervalSince(minPointX)) / spreadX
                let relativeOffsetY = (item.element.value - minPointY) / spreadY
                let offsetX = relativeOffsetX * width
                let offsetY = relativeOffsetY * height
                return CGPoint(
                        x: offsetX,
                        y: height - offsetY
                )
            }

            return points
        }

        static func createLinePath(for points: [CGPoint], rect: CGRect, closePath: Bool) -> Path {
            var path = Path()
            path.addLines(points)

            if closePath {
                path.addLine(to: .init(x: rect.size.width, y: rect.size.height))
                path.addLine(to: .init(x: 0, y: rect.size.height))
                path.closeSubpath()
            }
            return path
        }

        static func createQuadCurvePath(for points: [CGPoint], rect: CGRect, closePath: Bool) -> Path {
            var path = Path()

            guard points.count > 2 else { return path }

            if let firstPoint = points.first {
                path.move(to: firstPoint)
            }

            for index in 1..<points.count {
                let mid = calculateMidPoint(points[index - 1], points[index])
                path.addQuadCurve(to: mid, control: points[index - 1])
            }

            if let last = points.last {
                path.addLine(to: last)
            }

            if closePath {
                path.addLine(to: .init(x: rect.size.width, y: rect.size.height))
                path.addLine(to: .init(x: 0, y: rect.size.height))
                path.closeSubpath()
            }

            return path
        }

        static func calculateMidPoint(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
            let newMidPoint = CGPoint(x: (point1.x + point2.x)/2, y: (point1.y + point2.y)/2)
            return newMidPoint
        }
    }
}

