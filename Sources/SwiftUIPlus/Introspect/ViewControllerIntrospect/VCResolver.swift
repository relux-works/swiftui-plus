import Foundation

public struct ViewControllerResolver: UIViewControllerRepresentable {
    private let onResolve: VCResolveHandler?
    private let onAppearanceChange: VCAppearanceHandler?

    public init(
            onResolve: VCResolveHandler? = nil,
            onAppearanceChange: VCAppearanceHandler? = nil
    ) {
        self.onResolve = onResolve
        self.onAppearanceChange = onAppearanceChange
    }

    public func makeUIViewController(context: Context) -> ParentResolverViewController {
        ParentResolverViewController(
                onResolve: onResolve,
                onAppearanceChange: onAppearanceChange
        )
    }

    public func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context) {

    }
}
