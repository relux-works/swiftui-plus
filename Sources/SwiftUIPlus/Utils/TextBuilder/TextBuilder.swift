import SwiftUI

extension Text {
    static func build(_ segments: Segment..., separator: Segment? = nil) -> Text {
        let result = segments.indices.reduce(AttributedString()) { partialResult, index in
            var accumulated = partialResult
            accumulated += renderSegment(segments[index])

            let isLast = index == segments.count - 1
            if let separator, isLast.not {
                accumulated += renderSegment(separator)
            }

            return accumulated
        }

        return Text(result)
    }

    static private func renderSegment(_ segment: Segment) -> AttributedString {
        var segmentStr = AttributedString(segment.label)
        if let fgColor = segment.foregroundColor {
            segmentStr.foregroundColor = fgColor
        }
        if segment.underlined {
            segmentStr.underlineStyle = .single
        }
        if let link = segment.link {
            segmentStr.link = link
        }
        if let font = segment.font {
            segmentStr.font = font
        }
        return segmentStr
    }
}
