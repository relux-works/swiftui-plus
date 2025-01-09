import Foundation

extension Text {
    struct Segment {
        let label: String
        let font: Font?
        let foregroundColor: Color?
        let underlined: Bool
        let link: URL?

        init(
            label: String,
            font: Font? = nil,
            foregroundColor: Color? = nil,
            underlined: Bool = false,
            link: URL? = nil
        ) {
            self.label = label
            self.font = font
            self.foregroundColor = foregroundColor
            self.underlined = underlined
            self.link = link
        }
    }
}
