import SwiftUI

extension View {
    public var marquee: some View {
        self
            .modifier(MarqueeTextModifier(delay: 2, duration: 5, horizontalPadding: 0))
    }

    public func marquee(
        delay: CGFloat = 0,
        duration: CGFloat = 3,
        horizontalPadding: CGFloat = 0
    ) -> some View {
        self
            .modifier(MarqueeTextModifier(
                delay: delay,
                duration: duration,
                horizontalPadding: horizontalPadding
            ))
    }
}

struct MarqueeTextModifier: ViewModifier {
    @State private var alignment: Alignment = .leading
    @State private var globalRect: CGRect = .zero
    @State private var contentRect: CGRect = .zero
    @State private var offset: CGFloat = 0

    let delay: CGFloat
    let duration: CGFloat
    let horizontalPadding: CGFloat

    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            spacer
            content
            spacer
        }
        .storingSize(in: $globalRect)
        .opacity(0)
        .lineLimit(1)
        .overlay(alignment: alignment) {
            HStack(spacing: 0) {
                spacer
                content
                spacer
            }
            .fixedSize(horizontal: true, vertical: false)
            .offset(x: offset)
            .storingSize(in: $contentRect)
        }
        .clipped()
        .onAppear {
            if contentRect.width > globalRect.width {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    offset = globalRect.width - contentRect.width
                }
            }
        }
        .animation(
            .linear(duration: duration)
            .delay(delay)
            .repeatForever(autoreverses: false),
            value: offset
        )
        .drawingGroup()
    }
    
    private var spacer : some View {
        Spacer().frame(width: horizontalPadding)
    }
}
