import Foundation

public extension DatedLineChart {
    struct Point {
        public let value: Double
        public let timestamp: Date

        public init(value: Double, timestamp: Date) {
            self.value = value
            self.timestamp = timestamp
        }
    }

    enum Style {
        case line
        case curved
    }

    enum DatePeriod {
        case weekDays
        case monthDays
        case months
    }
}

extension DatedLineChart {
    struct Consts {
        static let axisLabelSize: CGFloat = 8
        static let yAxisPadding: CGFloat = 10
        static let xAxisPadding: CGFloat = 20

        struct Chart {
            static let paddingTop: CGFloat = 10
            static let paddingBottom: CGFloat = 10
            static let paddingLeading: CGFloat = 20
        }
    }
}