import SwiftUI

internal let minimalUserPercievedAnimationDuration: Double = 0.2
internal let longSystemTransitionDuration: Double = 0.75

public extension CGFloat {
    static var minimalUserPercieved: CGFloat {
        CGFloat(minimalUserPercievedAnimationDuration)
    }
}

public extension Double {
    static var minimalUserPercieved: Double {
        minimalUserPercievedAnimationDuration
    }
}

public extension Float {
    static var minimalUserPercieved: Float {
        Float(minimalUserPercievedAnimationDuration)
    }
}


public extension CGFloat {
    static var longSystemTransition: CGFloat {
        CGFloat(longSystemTransitionDuration)
    }
}

public extension Double {
    static var longSystemTransition: Double {
        longSystemTransitionDuration
    }
}

public extension Float {
    static var longSystemTransition: Float {
        Float(longSystemTransitionDuration)
    }
}
