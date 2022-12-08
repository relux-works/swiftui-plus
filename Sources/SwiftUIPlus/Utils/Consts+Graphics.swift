import SwiftUI

internal let minimalSystemPadding: Double = 16

public extension CGFloat {
    static var minimalSystem: CGFloat {
        CGFloat(minimalSystemPadding)
    }
}

public extension Double {
    static var minimalSystem: Double {
        minimalSystemPadding
    }
}

public extension Float {
    static var minimalSystem: Float {
        Float(minimalSystemPadding)
    }
}
