import SwiftUI

public typealias VCResolveHandler = (UIViewController)async ->Void

public extension View {
    func onVCResolve(perform: @escaping  VCResolveHandler) -> some View {
        self.modifier(ControllerResolveObserver(onResolve: perform))
    }
}

public struct ControllerResolveObserver: ViewModifier {
    private let onResolve: VCResolveHandler
    @State private var controllerId: ObjectIdentifier?

    public init(
        onResolve: @escaping VCResolveHandler
    ) {
        self.onResolve = onResolve
    }

    public func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver(onResolve: onResolveController)
                    .frame(width: 0, height: 0)
            )
    }

    private func onResolveController(_ c: UIViewController) async {
        let controllerId = ObjectIdentifier(c)
        guard self.controllerId != controllerId else { return }
        await onResolve(c)
    }
}
