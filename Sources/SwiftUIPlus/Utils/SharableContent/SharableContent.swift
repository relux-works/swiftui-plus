public protocol SharableView: Sendable {
    var previewView: any View {get}
    var contentView: any View {get}
}

public protocol SharableContent: SharableView {
    var previewImg: Image? {get}
    var contentImg: Image? {get}
    var preview: Image? {get async}
    var content: Image? {get async}
}

@available(iOS 16, *)
public extension SharableContent {
    var preview: Image? {
        get async {
            await getImage(for: previewView, withScale: 0.1)
        }
    }

    var content: Image? {
        get async {
            await getImage(for: contentView, withScale: 1)
        }
    }

    @MainActor
    private func getImage(for view: some View, withScale scale: CGFloat) async -> Image? {
        await withCheckedContinuation { continuation in
            let renderer = ImageRenderer(content: view)
            renderer.scale = scale
            guard let img = renderer.cgImage else {
                return continuation.resume(returning: .none)
            }

            return continuation.resume(returning: Image(decorative: img, scale: 1.0))
        }
    }
}
