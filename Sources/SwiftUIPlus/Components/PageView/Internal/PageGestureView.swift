/**
 *  SwiftUIPageView
 *  Copyright (c) Ciaran O'Brien 2022
 *  MIT license, see LICENSE file for details
 */

import SwiftUI


extension PageGestureView {
	
	init(
		alignment: Alignment,
		axis: Axis,
		baseOffset: CGFloat,
		@ViewBuilder content: @escaping () -> Content,
		pageLength: CGFloat,
		spacing: CGFloat,
		viewLength: CGFloat,
		activePageIndex: Binding<Int?>?
	) {
		
		self._animationState = .init(wrappedValue: AnimationState())
		self._pageState = .init(wrappedValue: PageState(activePageIndex: activePageIndex?.wrappedValue))
		self.alignment = alignment
		self.axis = axis
		self.baseOffset = baseOffset
		self.content = content
		self.pageLength = pageLength
		self.spacing = spacing
		self.viewLength = viewLength
		self.activePageIndex = activePageIndex
	}
	
}

extension Binding: Equatable where Value == Optional<Int> {
	public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
		return lhs.wrappedValue == rhs.wrappedValue
	}
}

internal struct PageGestureView<Content>: View where Content : View {
	@Environment(\.strictPageAlignment) private var strictPageAlignment
	@Environment(\.layoutDirection) private var layoutDirection
	@GestureState private var isDragging = false
	@StateObject private var animationState: AnimationState
	@StateObject private var pageState: PageState
	
	private var alignment: Alignment
	private var axis: Axis
	private var baseOffset: CGFloat
	@ViewBuilder private var content: () -> Content
	private var pageLength: CGFloat
	private var spacing: CGFloat
	private var viewLength: CGFloat
	private var activePageIndex: Binding<Int?>?
	
	var body: some View {
		PageLayoutView(alignment: alignment,
					   animationState: animationState,
					   axis: axis,
					   content: content,
					   pageLength: pageLength,
					   pageState: pageState,
					   spacing: spacing,
					   viewLength: viewLength)
		.modifier(DragAnimator(computedOffset: computedOffset, pageState: pageState))
		.offset(offset)
		.contentShape(Rectangle())
		.highPriorityGesture(gesture)
		.preference(key: InteractionProxyKey.self, value: InteractionProxy(id: pageState.id, moveTo: pageTo))
		.onChange(of: isCancelled, perform: onDragCancelled)
		.onReceive(pageState.$activePageIndex, perform: { self.activePageIndex?.wrappedValue = $0 })
		.onChange(of: activePageIndex, perform: adjustPageIdx)
	}
	
	
	private func adjustPageIdx(to newIdx: Binding<Int?>?) {
		adjustPageIdx(to: newIdx?.wrappedValue)
	}
	
	private func adjustPageIdx(to newIdx: Int?) {
		guard let newIdx else { return }
		guard (0..<pageState.viewCount).contains(newIdx) else { return }
		adjustPageIdx(to: CGFloat(newIdx))
	}
	
	private func adjustPageIdx(to newIdx: CGFloat?) {
		guard let newIdx = newIdx else { return }

		let distance = min(max(indexToOffset(newIdx), offsetRange.lowerBound), offsetRange.upperBound) - computedOffset
		
		animationState.dragAnimation = .dragEnded(distance: distance, velocity: 0, viewLength: viewLength)
		pageState.dragState = distance == 0 ? .ended : .ending
		pageState.initialIndex = nil
		withAnimation(animationState.dragAnimation?.speed(0.6)) {
			pageState.index = newIdx
			pageState.indexOffset = 0
		}
	}
	
	private var computedOffset: CGFloat {
		let computed = min(max(indexToOffset(pageState.index), offsetRange.lowerBound), offsetRange.upperBound)
		+ indexToOffset(pageState.indexOffset)
		
		if computed > offsetRange.upperBound {
			return (computed - offsetRange.upperBound).rubberBand(viewLength: viewLength) + offsetRange.upperBound
		} else if computed < offsetRange.lowerBound {
			return (computed - offsetRange.lowerBound).rubberBand(viewLength: viewLength) + offsetRange.lowerBound
		} else {
			return computed
		}
	}
	private var gesture: some Gesture {
		let minimumDistance: CGFloat
		
		switch pageState.dragState {
			case .dragging, .nearlyEnded, .ended: minimumDistance = 15
			case .ending: minimumDistance = 0
		}
		
		return DragGesture(minimumDistance: minimumDistance)
			.onChanged(onDragChanged)
			.onEnded(onDragEnded)
			.updating($isDragging) { _, s, _ in s = true }
	}
	private var indexRange: ClosedRange<CGFloat> {
		offsetToIndex(offsetRange.upperBound)...offsetToIndex(offsetRange.lowerBound)
	}
	private var isCancelled: Bool {
		switch pageState.dragState {
			case .dragging: return !isDragging
			case .ending, .nearlyEnded, .ended: return false
		}
	}
	private var offset: CGSize {
		switch axis {
			case .horizontal: return CGSize(width: baseOffset + computedOffset, height: 0)
			case .vertical: return CGSize(width: 0, height: baseOffset + computedOffset)
		}
	}
	private var offsetRange: ClosedRange<CGFloat> {
		guard pageState.viewCount > 1
		else { return 0...0 }
		
		var lowerBound = -(CGFloat(pageState.viewCount - 1) * (pageLength + spacing))
		var upperBound: CGFloat = 0
		
		
		// ❗️ strictPageAlignment is not propagated from environment
		// this does not work as expected
		// take time to debug
//		if !strictPageAlignment {
//			print(">>>>>>>strictPageAlignment: \(strictPageAlignment); \nstrictPageAlignment is likely not propagated from environment")
//			upperBound = -baseOffset
//			lowerBound += (viewLength - pageLength) - baseOffset
//		}
		
		return min(lowerBound, upperBound)...max(lowerBound, upperBound)
	}
	
	private func indexToOffset(_ index: CGFloat) -> CGFloat {
		-index * (pageLength + spacing)
	}
	private func offsetToIndex(_ offset: CGFloat) -> CGFloat {
		-offset / (pageLength + spacing)
	}
	private func onDragChanged(value: DragGesture.Value) {
		if let initialIndex = pageState.initialIndex {
			onDragUpdated(value: value, initialIndex: initialIndex)
		} else {
			onDragStarted(value: value)
		}
	}
	private func onDragCancelled(isCancelled: Bool) {
		guard isCancelled else { return }
		
		DispatchQueue.main.async {
			guard self.isCancelled else { return }
			
			let index = min(max(pageState.index, indexRange.lowerBound), indexRange.upperBound)
			var newIndex = round(index)
			
			if newIndex <= indexRange.lowerBound {
				newIndex = -.infinity
			} else if newIndex >= indexRange.upperBound {
				newIndex = .infinity
			}
			
			adjustPageIdx(to: newIndex)
		}
	}
	private func onDragEnded(value: DragGesture.Value) {
		let index = min(max(pageState.index + pageState.indexOffset, indexRange.lowerBound), indexRange.upperBound)
		var newIndex: CGFloat
		let velocity: CGFloat
		
		switch axis {
			case .horizontal: velocity = value.velocity.width * layoutDirectionWidthQuotient
			case .vertical: velocity = value.velocity.height
		}
		
		if velocity <= -.velocityThreshold {
			newIndex = floor(index + 1)
		} else if velocity >= .velocityThreshold {
			newIndex = ceil(index - 1)
		} else {
			newIndex = round(index)
		}
		
		if newIndex <= indexRange.lowerBound {
			newIndex = -.infinity
		} else if newIndex >= indexRange.upperBound {
			newIndex = .infinity
		}
		
		let distance = min(max(indexToOffset(newIndex), offsetRange.lowerBound), offsetRange.upperBound) - computedOffset
		
		animationState.dragAnimation = .dragEnded(distance: distance, velocity: velocity, viewLength: viewLength)
		pageState.dragState = distance == 0 ? .ended : .ending
		pageState.initialIndex = nil
		
		withAnimation(animationState.dragAnimation) {
			pageState.index = newIndex
			pageState.indexOffset = 0
		}
	}
	private func onDragStarted(value: DragGesture.Value) {
		let additionalOffset: CGFloat
		let initialOffset: CGFloat
		var offset: CGFloat
		
		switch axis {
			case .horizontal: additionalOffset = value.translation.width * layoutDirectionWidthQuotient
			case .vertical: additionalOffset = value.translation.height
		}
		
		switch pageState.dragState {
			case .dragging, .nearlyEnded, .ended: offset = computedOffset
			case .ending: offset = pageState.offset
		}
		
		if offset < offsetRange.lowerBound {
			initialOffset = additionalOffset - (offset - offsetRange.lowerBound).invertRubberBand(viewLength: viewLength)
			offset = offsetRange.lowerBound
		} else if offset > offsetRange.upperBound {
			initialOffset = additionalOffset - (offset - offsetRange.upperBound).invertRubberBand(viewLength: viewLength)
			offset = offsetRange.upperBound
		} else {
			initialOffset = additionalOffset
		}
		
		animationState.dragAnimation = .dragStarted
		pageState.dragState = .dragging
		pageState.initialIndex = offsetToIndex(initialOffset)
		
		withAnimation(animationState.dragAnimation) {
			pageState.index = offsetToIndex(offset)
			pageState.indexOffset = offsetToIndex(additionalOffset - initialOffset)
		}
	}
	private func onDragUpdated(value: DragGesture.Value, initialIndex: CGFloat) {
		let additionalOffset: CGFloat
		
		switch axis {
			case .horizontal: additionalOffset = value.translation.width * layoutDirectionWidthQuotient
			case .vertical: additionalOffset = value.translation.height
		}
		
		pageState.indexOffset = offsetToIndex(additionalOffset) - initialIndex
	}
	private func pageTo(index: CGFloat) {
		let newIndex: CGFloat
		
		if index <= indexRange.lowerBound {
			newIndex = -.infinity
		} else if index >= indexRange.upperBound {
			newIndex = .infinity
		} else {
			newIndex = index
		}
		
		let distance = min(max(indexToOffset(newIndex), offsetRange.lowerBound), offsetRange.upperBound) - computedOffset
		
		guard pageState.index != newIndex else {
#if DEBUG
			print("will not move page, index has not changed")
#endif
			return
		}
		
		pageState.dragState = distance == 0 ? .ended : .ending
		pageState.index = newIndex
		pageState.indexOffset = 0
	}
	
	private var layoutDirectionWidthQuotient: CGFloat {
		switch layoutDirection {
			case .leftToRight:
				return 1
			case .rightToLeft:
				return -1
			@unknown default:
				return 1
		}
	}
}
