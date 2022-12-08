import Foundation
import SwiftUI

public extension UIImage.Orientation {

    func getDegree() -> Double {
        switch self {
        case .up, .upMirrored:
            return 0.0
        case .right, .rightMirrored:
            return -90.0
        case .down, .downMirrored:
            return 180.0
        case .left, .leftMirrored:
            return 90.0
        default:
            return 0
        }
    }

    func isMirror() -> Bool {
        switch self {
        case .up, .right, .down, .left:
            return false
        case .leftMirrored, .upMirrored, .downMirrored, .rightMirrored:
            return true
        default:
            return false
        }
    }
}

public extension UIImage {
    func normaliseImageOrientation() -> UIImage {
        guard let cgImage = self.cgImage else { return self }

        let originalWidth = cgImage.width
        let originalHeight = cgImage.height
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let bitmapInfo = cgImage.bitmapInfo

        guard let colorSpace = cgImage.colorSpace else { return self }

        let orientation = self.imageOrientation
        let degreesToRotate = orientation.getDegree()
        let mirrored = orientation.isMirror()

        var width = originalWidth
        var height = originalHeight

        let radians = degreesToRotate * Double.pi / 180.0
        let swapWidthHeight = Int(degreesToRotate / 90) % 2 != 0

        if swapWidthHeight {
            swap(&width, &height)
        }

        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        context?.translateBy(x: CGFloat(width) / 2.0, y: CGFloat(height) / 2.0)
        if mirrored {
            context?.scaleBy(x: -1.0, y: 1.0)
        }
        context?.rotate(by: CGFloat(radians))
        if swapWidthHeight {
            swap(&width, &height)
        }
        context?.translateBy(x: -CGFloat(width) / 2.0, y: -CGFloat(height) / 2.0)

        context?.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(originalWidth), height: CGFloat(originalHeight)))
        guard let res = context?.makeImage() else {
            return self
        }

        let orientedImg = UIImage(cgImage: res)
        return orientedImg
    }
}

public extension UIImage {
    func croppedToSquare(rect: CGRect) -> UIImage {
        var rectTransform: CGAffineTransform = .identity

        func rad(_ degree: Double) -> CGFloat { CGFloat(degree / 180.0 * .pi) }

        switch imageOrientation {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: rad(90)).translatedBy(x: 0, y: -self.size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: rad(-90)).translatedBy(x: -self.size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: rad(-180)).translatedBy(x: -self.size.width, y: -self.size.height)
        default:
            rectTransform = .identity
        }

        rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale)

        if let imageRef = self.cgImage!.cropping(to: rect.applying(rectTransform)) {
            return UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        } else {
            print("failed to crop")
            return self
        }
    }
}
