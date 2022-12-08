import SwiftUI

public struct ShareSheet: UIViewControllerRepresentable {
    @Binding private var items : [Any]

    public init(
            items: Binding<[Any]>
    ) {
        self._items = items
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {

    }
}