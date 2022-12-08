import SwiftUI
import StoreKit

public struct AppHelper {
    public static func rateAppRequest() {
        guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("UNABLE TO GET CURRENT SCENE")
            return
        }
        SKStoreReviewController.requestReview(in: currentScene)
    }

    public static func sendEmail(email: String, onEmailClientUnavailable: () -> Void = {}) {
        let subject = ""
        let bodyText = ""

        guard let coded = "mailto:\(email)?subject=\(subject)&body=\(bodyText)"
                .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        else {
            return
        }

        guard let emailUrl = URL(string: coded) else {
            return
        }

        guard UIApplication.shared.canOpenURL(emailUrl) else {
            onEmailClientUnavailable()
            return
        }

        UIApplication.shared.open(emailUrl, options: [:]) { result in
            if !result {
                print("Unable to send email.")
            }
        }
    }

    static public func openUrl(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }


    #warning("refactor to action in Environment")
    static public func openAppSettings() {
        openUrl(url: UIApplication.openSettingsURLString)
    }
}
