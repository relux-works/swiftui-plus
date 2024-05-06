import SwiftUI
import Foundation

public struct CallHelper {
    public enum Err: Error {
        case failedToParse(number: String)
    }

    @discardableResult
    public static func callTo(_ number: String) async -> Result<Bool, Err> {
        await withCheckedContinuation { ctx in
            let encodedNumber = number.replacingOccurrences(of: "#", with: "%23")
            guard let number = URL(string: "tel://" + encodedNumber) else {
                ctx.resume(returning: .failure(.failedToParse(number: number)))
                return
            }
            Task { @MainActor in
                UIApplication.shared.open(number, options: [:], completionHandler: { result in
                    ctx.resume(returning: .success(result))
                })
            }
        }
    }
}