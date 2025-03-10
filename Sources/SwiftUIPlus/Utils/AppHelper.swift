import SwiftUI
import StoreKit
import LinkPresentation


public struct AppHelper {
}

// open url
public extension AppHelper {
    @MainActor
    static func openUrl(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        self.openUrl(url: url)
    }

    @MainActor
    static func openUrl(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @MainActor
    static func openAppSettings() {
        openUrl(url: UIApplication.openSettingsURLString)
    }
}

// send email
public extension AppHelper {
    @MainActor
     static func sendEmail(email: String, subject: String = "", bodyText: String = "", onEmailClientUnavailable: () -> Void = {}) {
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
}

// share activity sheet
public extension AppHelper {
    @MainActor
    static func openShareSheet(activityItems: [MyActivityItemSource], onComplete: (()->())? = nil) {
        self.openShareSheet(items: activityItems, onComplete: onComplete)
    }

    @MainActor
    static func openShareSheet(items: [Any], onComplete: (()->())? = nil) {
        let activityView = UIActivityViewController(activityItems: items, applicationActivities: nil)
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }

        if let windowScene = scene as? UIWindowScene {
            // first of all we are looking into modal view controller which is presented at the current time
            // if there is no presentedViewController, we work with a rootViewController instead
            let currentViewController = windowScene.keyWindow?.rootViewController?.presentedViewController
                ?? windowScene.keyWindow?.rootViewController

            currentViewController?.present(activityView, animated: true, completion: onComplete)
        }
    }


    class MyActivityItemSource: NSObject, UIActivityItemSource {
        private var item: Any
        private var thumbnail: UIImage?
        private var title: String
        private var text: String

        public init(title: String, text: String, item: Any, thumbnail: UIImage?) {
            self.thumbnail = thumbnail
            self.title = title
            self.text = text
            self.item = item
            super.init()
        }

        public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
            item
        }

        public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
            item
        }

        public func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
            title
        }

        public func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
            let metadata = LPLinkMetadata()
            metadata.title = title

            if let thumbnail {
                metadata.iconProvider = NSItemProvider(object: thumbnail)
            }
            //This is a bit ugly, though I could not find other ways to show text content below title.
            //https://stackoverflow.com/questions/60563773/ios-13-share-sheet-changing-subtitle-item-description
            //You may need to escape some special characters like "/".
            metadata.originalURL = URL(fileURLWithPath: text)
            return metadata
        }

    }
}

// rate us request
public extension AppHelper {
    @MainActor
    static func rateAppRequest() {
        guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("UNABLE TO GET CURRENT SCENE")
            return
        }
        SKStoreReviewController.requestReview(in: currentScene)
    }
}

// notification badges
public extension AppHelper {
    @MainActor
    static func removeBadgesForApp() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    @MainActor
    static func setAppBadge(to number: Int) {
        UIApplication.shared.applicationIconBadgeNumber = max(0, number)
    }
}
