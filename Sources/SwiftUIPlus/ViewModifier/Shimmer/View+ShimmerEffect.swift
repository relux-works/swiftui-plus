import SwiftUI

public extension View {
    @ViewBuilder
    func shimmer(
        isActive: Bool,
        configuration: ShimmerEffect.Configuration = .default
    ) -> some View {
        if isActive {
            modifier(ShimmerEffect(configuration: configuration))
        } else {
            self
        }
    }
    
    @ViewBuilder
    func shimmer(
        ifNil optional: Optional<Any>,
        configuration: ShimmerEffect.Configuration = .default
    ) -> some View {
        if optional == nil {
            modifier(ShimmerEffect(configuration: configuration))
        } else {
            self
        }
    }
}

public struct ShimmerEffect: ViewModifier {
    private let configuration: Configuration
    @State private var moveTo: CGFloat = -0.7
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .hidden()
            .overlay {
                shimmerOverlay(content)
            }
    }
    
    private func shimmerOverlay(_ content: Content) -> some View {
        Rectangle()
            .fill(configuration.tint)
            .mask(content)
            .overlay {
                shimmerAnimation(content: content)
            }
    }
    
    private func shimmerAnimation(content: Content) -> some View {
        GeometryReader { geometry in
            let extraOffset = (geometry.size.height / 2.5) + configuration.blur
            
            Rectangle()
                .fill(configuration.highlight)
                .mask {
                    shimmerGradient(extraOffset: extraOffset, size: geometry.size)
                }
                .blendMode(configuration.blendMode)
                .mask(content)
        }
        .onAppear(perform: startAnimation)
    }
    
    private func shimmerGradient(extraOffset: CGFloat, size: CGSize) -> some View {
        Rectangle()
            .fill(
                .linearGradient(
                    colors: [
                        .white.opacity(0),
                        configuration.highlight.opacity(configuration.highlightOpacity),
                        .white.opacity(0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .blur(radius: configuration.blur)
            .rotationEffect(.init(degrees: -70))
            .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
            .offset(x: size.width * moveTo)
            .animation(
                .linear(duration: configuration.speed)
                .repeatForever(autoreverses: false),
                value: moveTo
            )
    }
    
    private func startAnimation() {
        DispatchQueue.main.async {
            moveTo = 0.7
        }
    }
}

// MARK: Configuration

public extension ShimmerEffect {
    struct Configuration {
        var tint: Color
        var highlight: Color
        var blur: CGFloat
        var highlightOpacity: CGFloat
        var speed: CGFloat
        var blendMode: BlendMode
        
        public init(tint: Color, highlight: Color, blur: CGFloat, highlightOpacity: CGFloat = 1, speed: CGFloat = 2, blendMode: BlendMode = .normal) {
            self.tint = tint
            self.highlight = highlight
            self.blur = blur
            self.highlightOpacity = highlightOpacity
            self.speed = speed
            self.blendMode = blendMode
        }
    }
}

extension ShimmerEffect.Configuration: Sendable { }

public extension ShimmerEffect.Configuration {
    static let `default` = Self(
        tint: .gray.opacity(0.3),
        highlight: .white,
        blur: 5
    )
    
    static let light = Self(
        tint: .white.opacity(0.5),
        highlight: .white,
        blur: 5
    )
    
    static let subtle = Self(
        tint: .gray.opacity(0.2),
        highlight: .white,
        blur: 15
    )
    
    static let indigoStyle = Self(
        tint: .white.opacity(0.4),
        highlight: .white,
        blur: 5
    )
}
