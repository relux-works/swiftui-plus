import Foundation
import UIKit

public enum NavBarCustomization {

	public static func customiseNavBar(
		accentColor: UIColor,
		backgroundColor: UIColor,
		largeTitleFont : UIFont,
		inlineTitleFont : UIFont
	) {
		let appearance = UINavigationBarAppearance()
		appearance.backgroundColor = backgroundColor

		let scaledInlineTitleFont = UIFontMetrics.default.scaledFont(for: inlineTitleFont)
		appearance.titleTextAttributes = [.foregroundColor: accentColor, .font: scaledInlineTitleFont]

        let scaledLargeTitleFont = UIFontMetrics.default.scaledFont(for: largeTitleFont)
		appearance.largeTitleTextAttributes = [.foregroundColor: accentColor, .font: scaledLargeTitleFont]

		/* todo: CAUTION!
			it changes button's text foreground color only without chevron
			and it's better to change tintColor for all the appearance
		*/
		//appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: accentColor]
		UINavigationBar.appearance().standardAppearance = appearance
		//UINavigationBar.appearance().scrollEdgeAppearance = appearance

		/* todo: ATTENTION!
			it sets tint color for even custom buttons and chevrons
		*/
		UINavigationBar.appearance().tintColor = accentColor
	}
}
