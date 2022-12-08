import SwiftUI

public extension StringProtocol where Self == String {
    static func layoutNumericGuardian(length: Int = 10) -> String {
        var string = ""
        for _ in 1...length {
            string.append("0")
        }
        return string
    }
    static var layoutNumericGuardian: String {
        return layoutNumericGuardian()
    }
}

public extension StringProtocol where Self == String {
    static var empty: String {
        return ""
    }
}
