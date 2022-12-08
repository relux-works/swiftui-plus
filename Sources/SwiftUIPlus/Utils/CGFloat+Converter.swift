import CoreGraphics

extension CGFloat {
    var asIntTruncating: Int {
        Int(self)
    }
}

public extension Double {
	var asCGFloat: CGFloat {
		CGFloat(self)
	}
}

public extension CGFloat {
	init?(_ val: Double?) {
		guard let v = val else { return nil }
		self = v
	}
}

