import SwiftUI

public struct EqualSize: ViewModifier {
    @Environment(\.size) private var size
    @State private var frame: CGRect = .zero

    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(key: SizeKey.self, value: [proxy.size])
                }
            )
            .frame(width: size?.width, height: size?.height)
    }
}

public struct EqualSizes: ViewModifier {
    @State private var longestViewWidth: CGFloat?
    @State private var tallestViewHeight: CGFloat?

    public func body(content: Content) -> some View {
        content
                .onPreferenceChange(SizeKey.self, perform: { sizes in
                    guard sizes.count > 0 else {
                        #if DEBUG
                        // switch to os.log logger
                        print(">> preference has not been passed up the hierarchy")
                        #endif
                        return
                    }
                    self.longestViewWidth = sizes.map { $0.width }.max()
                    self.tallestViewHeight = sizes.map { $0.height }.max()
                })
                .environment(\.size, size(longestViewWidth, tallestViewHeight))
    }

    private func size(_ width: CGFloat?, _ height: CGFloat?) -> CGSize? {
        guard let width = width, let height = height else { return nil }
        return CGSize(width: width, height: height)
    }
}


public extension View {
    func equalSize() -> some View {
        self.modifier(EqualSize())
    }

    func equalSizes() -> some View {
        self.modifier(EqualSizes())
    }
}
