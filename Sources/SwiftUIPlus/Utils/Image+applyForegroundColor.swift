import Foundation

extension Image {
    @ViewBuilder
    public func applyForegroundColor(_ color: Color, when flag: Bool) -> some View {
        if flag {
            self
                .renderingMode(.template)
                .foregroundStyle(color)
        } else {
            self
        }
    }
}
