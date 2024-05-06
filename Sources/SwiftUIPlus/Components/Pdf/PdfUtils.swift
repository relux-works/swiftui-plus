import Foundation
import PDFKit

public enum PdfUtils {
    public static func generatePdfThumbnail(of thumbnailSize: CGSize , for doc: Data, atPage pageIndex: Int, displayBox: PDFDisplayBox = .artBox) -> UIImage? {
        PDFDocument(data: doc)?
            .page(at: pageIndex)?
            .thumbnail(of: thumbnailSize, for: displayBox)
    }
}