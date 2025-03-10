import SwiftUI

public struct SwipeGestureProxy: UIViewRepresentable {

	@Environment(\.layoutDirection) private var layoutDirection
    @Binding var pageIndex: Int?
    let rangeOfPages: ClosedRange<Int>
    
    public init?(pageIndex: Binding<Int?>, numberOfPages: Int?) {
        guard let numberOfPages = numberOfPages else {
            return nil
        }
        let lastPageIdx = numberOfPages - 1
        guard lastPageIdx > 0 else {
            return nil
        }
                
        self.rangeOfPages = 0...numberOfPages-1
        self._pageIndex = pageIndex
    }

    public func makeCoordinator() -> SwipeGestureProxy.Coordinator {
		return SwipeGestureProxy.Coordinator(parent: self, layoutDirection: layoutDirection)
    }

    public func makeUIView(context: UIViewRepresentableContext<SwipeGestureProxy>) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let left = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.left))
        left.direction = .left

        let right = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.right))
        right.direction = .right

        view.addGestureRecognizer(right)
        view.addGestureRecognizer(left)
        return view
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SwipeGestureProxy>) {

    }

    @MainActor
    public class Coordinator: NSObject{
			
        var parent : SwipeGestureProxy
		let layoutDirection: LayoutDirection

        init(
			parent : SwipeGestureProxy,
			layoutDirection: LayoutDirection
		) {
            self.parent = parent
			self.layoutDirection = layoutDirection
        }

        @objc func left(){
			switch layoutDirection {
				case .leftToRight:
					towardsLeadingEdge()
				case .rightToLeft:
					towardsTrailingEdge()
				@unknown default:
					towardsLeadingEdge()
			}
        }

        @objc func right(){
			switch layoutDirection {
				case .leftToRight:
					towardsTrailingEdge()
				case .rightToLeft:
					towardsLeadingEdge()
				@unknown default:
					towardsTrailingEdge()
			}
        }
		
		private func towardsLeadingEdge() {
			guard parent.pageIndex != nil else {
				return
			}
			let newIdx = parent.pageIndex! + 1
			if parent.rangeOfPages.contains(newIdx) {
				parent.pageIndex! += 1
			}
		}
		
		private func towardsTrailingEdge() {
			guard parent.pageIndex != nil else {
				return
			}
			let newIdx = parent.pageIndex! - 1
			if parent.rangeOfPages.contains(newIdx) {
				parent.pageIndex! -= 1
			}
		}
		
    }
}
