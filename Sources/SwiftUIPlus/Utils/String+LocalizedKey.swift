import SwiftUI

public extension String {
	var localizedKey: LocalizedStringKey {
		.init(self)
	}
}
