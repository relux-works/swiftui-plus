import Foundation
import PDFKit

public extension PDFKitView {
    enum VType {
        case remote(url: URL, config: Config = .defaultValue)
        case local(data: Data, config: Config = .defaultValue)
    }

    struct Config: Sendable {
        let bgColor: UIColor
        let minScaleFactor: CGFloat?
        let maxScaleFactor: CGFloat?
        let displayMode: PDFDisplayMode
        let displayDirection: PDFDisplayDirection

        public init(
            bgColor: UIColor = .clear,
            minScaleFactor: CGFloat? = .none,
            maxScaleFactor: CGFloat? = .none,
            displayMode: PDFDisplayMode = .singlePageContinuous,
            displayDirection: PDFDisplayDirection = .vertical
        ) {
            self.bgColor = bgColor
            self.minScaleFactor = minScaleFactor
            self.maxScaleFactor = maxScaleFactor
            self.displayMode = displayMode
            self.displayDirection = displayDirection
        }

        public static let defaultValue: Self = .init()
    }
}

public struct PDFKitView: View {
    var type: VType

    public init(type: VType) {
        self.type = type
    }
    
    public var body: some View {
        PDFKitRepresentedView(type)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let type: PDFKitView.VType

    init(_ type: PDFKitView.VType) {
        self.type = type
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()

        switch type {
        case let .remote(url, cfg):
            pdfView.document = PDFDocument(url: url)
            pdfView.apply(cfg)
        case let .local(data, cfg):
            pdfView.document = PDFDocument(data: data)
            pdfView.apply(cfg)
        }

        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.translatesAutoresizingMaskIntoConstraints = false

        DispatchQueue.main.async { [weak pdfView] in
            pdfView?.autoScales = true
        }

        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
    }
}

extension PDFView {
    func apply(_ config: PDFKitView.Config) {
        self.backgroundColor = config.bgColor
        self.displayMode = config.displayMode
        self.displayDirection = config.displayDirection
        self.minScaleFactor = config.minScaleFactor ?? self.minScaleFactor
        self.maxScaleFactor = config.maxScaleFactor ?? self.maxScaleFactor
    }
}

