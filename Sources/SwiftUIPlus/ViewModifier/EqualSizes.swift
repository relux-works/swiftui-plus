import SwiftUI

public extension EqualSizes {
    enum HandleSize {
        case height
        case width
        case all
    }
}

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
            .frame(width: size.width, height: size.height)
    }
}

public struct EqualSizes: ViewModifier {
    @State private var maxWidth : CGFloat?
    @State private var maxHeight : CGFloat?
    private let handleSize: HandleSize

    init(handleSize: HandleSize = .all) {
        self.handleSize = handleSize
    }

    public func body(content: Content) -> some View {
        content
            .onPreferenceChange(SizeKey.self, perform: { sizes in
                guard sizes.count > 0 else { return }
                Task { @MainActor in
                    switch handleSize {
                        case .width:
                            self.maxWidth = sizes.map { $0.width }.max()
                        case .height:
                            self.maxHeight = sizes.map { $0.height }.max()
                        case .all:
                            self.maxWidth = sizes.map { $0.width }.max()
                            self.maxHeight = sizes.map { $0.height }.max()
                    }
                }
            })
            .environment(\.size, (width: maxWidth, height: maxHeight))
    }
}


public extension View {
    func equalSize() -> some View {
        self.modifier(EqualSize())
    }

    func equalSizes(sizeType: EqualSizes.HandleSize = .all) -> some View {
        self.modifier(EqualSizes(handleSize: sizeType))
    }
}
