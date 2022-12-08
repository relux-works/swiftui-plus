import SwiftUI

//
// StackOverflow users
// Mike R
// Asperi


public extension View {
	
	func erasesSuperviewBackground() -> some View {
		self.modifier(SuperviewBackgroundEraserModifier(background: .clear))
	}
	
	func replacesSuperviewBackground(withColor color: Color) -> some View {
		self.modifier(SuperviewBackgroundEraserModifier(background: .color(color)))
	}
	
	func replacesSuperviewBackground(withMaterial material: UIBlurEffect.Style) -> some View {
		self.modifier(SuperviewBackgroundEraserModifier(background: .material(material)))
	}
}


extension SuperviewBackgroundEraserModifier {
	enum Background {
		case clear
		case color(Color)
		case material(UIBlurEffect.Style)
	}
}

struct SuperviewBackgroundEraser: UIViewRepresentable {
	func makeUIView(context: Context) -> some UIView {
		let view = UIView()
		DispatchQueue.main.async {
			view.superview?.superview?.backgroundColor = .clear
			view.superview?.superview?.backgroundColor = .clear
		}
		return view
	}
	func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct SuperviewBackgroundEraserModifier: ViewModifier {
	let background: Background
	
	func body(content: Content) -> some View {
		switch background {
			case .clear:
				content
					.background(SuperviewBackgroundEraser())
			case let .color(color):
				content
					.background(
						SuperviewBackgroundEraser()
							.background(
								color
									.ignoresSafeArea(.all)
							)
					)
			case let .material(material):
				content
					.background(
						SuperviewBackgroundEraser()
							.background(
								SystemMaterial(material)
									.ignoresSafeArea(.all)
								//.overlay(material)
							)
					)
		}
	}
}
