/**
*  SwiftUIPageView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI
import Combine

internal final class PageState: ObservableObject {
    private var pipelines: Set<AnyCancellable> = []
	private let queue = DispatchQueue(label: "PageState", qos: .default)

    @Published var dragState = DragState.ended
    @Published var index: CGFloat
    @Published var activePageIndex: Int?
    @Published var indexOffset: CGFloat = 0
    @Published var initialIndex: CGFloat? = nil
    var offset: CGFloat = 0
    @Published var viewCount = 0

    let id = UUID()
    
    enum DragState {
        case dragging
        case ending
        case nearlyEnded
        case ended
    }

    init(activePageIndex: Int? = nil) {
        if let activePageIndex = activePageIndex {
            self.index = CGFloat(activePageIndex)
            self.activePageIndex = activePageIndex
        } else {
            self.index = 0
            self.activePageIndex = nil
        }
        Publishers
                .CombineLatest($index, $viewCount)
				.subscribe(on: queue)
				.receive(on: queue)
                .map { rawIdx, total in
                    guard rawIdx != -.infinity else {
                        return 0
                    }
                    guard rawIdx != .infinity else {
                        return Int(total) - 1
                    }

                    return Int(rawIdx.rounded())
                }
                .removeDuplicates()
				.throttle(for: 0.016, scheduler: DispatchQueue.main, latest: true)
				.receive(on: DispatchQueue.main)
                .assign(to: &$activePageIndex)
    }
}
