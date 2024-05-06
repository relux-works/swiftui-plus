import Foundation
import PDFKit

public extension PDFKitView {
    enum VType {
        case remote(url: URL)
        case local(data: Data)
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
        case let .remote(url):
            pdfView.document = PDFDocument(url: url)
        case let .local(data):
            pdfView.document = PDFDocument(data: data)
        }

        pdfView.backgroundColor = .clear
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
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

