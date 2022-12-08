import SwiftUI

public struct MovinCircleStroke<StrokeContent: ShapeStyle>: View {
    @Binding var start: Double
    @Binding var progress: Double
    let strokeContent: StrokeContent
    let style: StrokeStyle
    
    public init(
        startingAt: Binding<Double> = .constant(0),
        progress: Binding<Double>,
        strokeContent: StrokeContent,
        style: StrokeStyle
    ) {
        self._start = startingAt
        self._progress = progress
        self.strokeContent = strokeContent
        self.style = style
    }
    
    public var body: some View {
        Circle()
            .trim(from: start, to: progress)
            .stroke(strokeContent, style: style)
            .rotationEffect(.degrees(-90)) //move to a modifier
    }
    
}
