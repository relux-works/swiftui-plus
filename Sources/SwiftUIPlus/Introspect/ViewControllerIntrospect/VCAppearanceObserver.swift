import SwiftUI

public typealias VCAppearanceHandler = (UIViewController, ControllerAppearanceType)async->Void

public extension View {
    func onAppearanceChange(perform: @escaping VCAppearanceHandler) -> some View {
        self.modifier(ControllerAppearanceObserver(onAppearanceChange: perform))
    }
}

public struct ControllerAppearanceObserver: ViewModifier {
    private let onAppearanceChange: VCAppearanceHandler

    public init(
            onAppearanceChange: @escaping VCAppearanceHandler
    ) {
        self.onAppearanceChange = onAppearanceChange
    }

    public func body(content: Content) -> some View {
        content
                .overlay(
                        ViewControllerResolver(
                                onAppearanceChange: onAppearanceChange
                        )
                                .frame(width: 0, height: 0)
                )
    }
}