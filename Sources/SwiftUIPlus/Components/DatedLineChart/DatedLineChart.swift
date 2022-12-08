import SwiftUI

public struct DatedLineChart: View {
    private let props: Props
    public init(props: Props) {
        self.props = props
    }

    public var body: some View {
        ZStack {
            yAxis
                    .padding(.bottom, Consts.yAxisPadding)
            xAxis
                    .padding(.leading, Consts.xAxisPadding)
            chart
                    .padding(.top, Consts.Chart.paddingTop)
                    .padding(.bottom, Consts.Chart.paddingBottom)
                    .padding(.leading, Consts.Chart.paddingLeading)
                    .clipped()
        }
    }

    private var chart: some View {
        ChartPath(
                points: props.points,
                progress: 1,
                style: props.pathStyle,
                rangeX: props.rangeX,
                rangeY: props.rangeY
        )
                .stroke(props.lineGradient, lineWidth: props.lineWidth)
    }

    private var yAxisDeltaY: Double {
        ((props.rangeY.upperBound - props.rangeY.lowerBound) / 5)
    }
    private var xAxisDeltaX: Double {
        props.rangeX.upperBound.timeIntervalSince(props.rangeX.lowerBound) / 7
    }

    private var yAxis: some View {
        VStack {
            yAxisElem(props.rangeY.upperBound.asInt.description)
            yAxisElem((props.rangeY.upperBound - yAxisDeltaY).asInt.description)
            yAxisElem((props.rangeY.upperBound - 2*yAxisDeltaY).asInt.description)
            yAxisElem((props.rangeY.upperBound - 3*yAxisDeltaY).asInt.description)
            yAxisElem((props.rangeY.upperBound - 4*yAxisDeltaY).asInt.description)
            yAxisElem(props.rangeY.lowerBound.asInt.description, noSpacer: true)
        }.font(.system(size: 8))
    }

    private func yAxisElem(_ txt: String, noSpacer: Bool = false) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(txt).padding(0)
                Spacer()
            }.overlay(Divider(),alignment: .bottom)
            if noSpacer.not {
                Spacer(minLength: 0).padding(0)
            }
        }
    }

    private var xAxis: some View {
        VStack(spacing: 0) {
            Spacer()
            switch xAxisPeriod {
            case .weekDays: xAxisWeekDays
            case .monthDays: xAxisMonthDays
            case .months: xAxisMonths
            }
        }.font(.system(size: 8))
    }

    @ViewBuilder
    private var xAxisWeekDays: some View {
        let deltaX: Double = xAxisDeltaX
        let startDate = props.rangeX.lowerBound
        HStack(spacing: 0) {
            xAxisLabel(props.rangeX.lowerBound.formatted(dateFormat: .dateAsDayOfWeekShort))
            xAxisLabel(startDate.addingTimeInterval(deltaX).formatted(dateFormat: .dateAsDayOfWeekShort))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 2).formatted(dateFormat: .dateAsDayOfWeekShort))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 3).formatted(dateFormat: .dateAsDayOfWeekShort))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 4).formatted(dateFormat: .dateAsDayOfWeekShort))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 5).formatted(dateFormat: .dateAsDayOfWeekShort))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 6).formatted(dateFormat: .dateAsDayOfWeekShort))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 7).formatted(dateFormat: .dateAsDayOfWeekShort), noSpacer: true)
        }
    }

    @ViewBuilder
    private var xAxisMonthDays: some View {
        let deltaX: Double = xAxisDeltaX
        let startDate = props.rangeX.lowerBound
        HStack(spacing: 0) {
            xAxisLabel(props.rangeX.lowerBound.formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 2).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 3).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 4).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 5).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 6).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 7).formatted(dateFormat: .dateAsDDMM), noSpacer: true)
        }
    }

    @ViewBuilder
    private var xAxisMonths: some View {
        let deltaX: Double = xAxisDeltaX
        let startDate = props.rangeX.lowerBound
        HStack(spacing: 0) {
            xAxisLabel(props.rangeX.lowerBound.formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 2).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 3).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 4).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 5).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 6).formatted(dateFormat: .dateAsDDMM))
            xAxisLabel(startDate.addingTimeInterval(deltaX * 7).formatted(dateFormat: .dateAsDDMM), noSpacer: true)
        }
    }

    private func xAxisLabel(_ txt: String, noSpacer: Bool = false) -> some View {
        HStack {
            Text(txt)
            if noSpacer.not {
                Spacer()
            }
        }
    }

    private var xAxisPeriod: DatePeriod {
        let seconds = props.rangeX.upperBound.timeIntervalSince(props.rangeX.lowerBound)
        let days = seconds / 60 / 60 / 24
        switch days.rounded() {
        case 0...7: return .weekDays
        case 7...30: return .monthDays
        default: return .months
        }
    }
}

