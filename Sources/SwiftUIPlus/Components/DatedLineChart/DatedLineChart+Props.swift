import Foundation

public extension DatedLineChart {
    struct Props {
        let points: [Point]
        let pathStyle: DatedLineChart.Style
        let lineWidth: CGFloat
        let lineGradient: LinearGradient
        let rangeX: ClosedRange<Date>
        let rangeY: ClosedRange<Double>

        public init(
                points: [Point],
                pathStyle: DatedLineChart.Style,
                lineWidth: CGFloat,
                lineGradient: LinearGradient,
                rangeX: ClosedRange<Date>,
                rangeY: ClosedRange<Double>
        ) {
            self.points = points
            self.pathStyle = pathStyle
            self.lineWidth = lineWidth
            self.lineGradient = lineGradient
            self.rangeX = rangeX
            self.rangeY = rangeY
        }
    }
}
