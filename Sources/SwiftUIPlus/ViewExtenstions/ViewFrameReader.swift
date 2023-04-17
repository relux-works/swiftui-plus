import SwiftUI
import Combine
import Foundation

public extension View {
	func storingSize(
		in storage: PassthroughSubject<CGRect, Never>,
		onQueue queue: DispatchQueue,
		space: CoordinateSpace = .local,
		when condition: ((CGRect)->Bool)? = nil,
		logToConsole: Bool = false
	) -> some View {
		self.modifier(ViewFrameReader(storage: storage, onQueue: queue, coordinateSpace: space, when: condition, logToConsole: logToConsole) )
	}
}

extension ViewFrameReader {
	final class LocalState: ObservableObject {
		let queue: DispatchQueue
		
		
		init(queue: DispatchQueue) {
			self.queue = queue
		}
	}
}

struct ViewFrameReader: ViewModifier {
	
	@StateObject private var ls: LocalState
	
	@State private var coordinateSpace: CoordinateSpace
	@State private var condition: ((CGRect)->Bool)?
	@State private var logToConsole: Bool
	private let storage: PassthroughSubject<CGRect, Never>
	
	init(
		storage: PassthroughSubject<CGRect, Never>,
		onQueue queue: DispatchQueue,
		coordinateSpace space: CoordinateSpace = .local,
		when condition: ((CGRect)->Bool)? = nil,
		logToConsole: Bool = false
	) {
		self._coordinateSpace = State(initialValue: space)
		self._condition = State(initialValue: condition)
		self._logToConsole = State(initialValue: logToConsole)
		self.storage = storage
		self._ls = StateObject(wrappedValue: LocalState(queue: queue))
	}
	
	func body(content: Content) -> some View {
		content
			.background(
				GeometryReader { reader($0) }
			)
	}

	private func reader(_ geometryReader: GeometryProxy) -> Color {

		ls.queue.sync {
			let frame = geometryReader.frame(in: coordinateSpace)
			#if DEBUG
			if logToConsole {
				print("storing size for: \(frame)")
			}
			#endif

			if let condition = condition {
				// condition is set, we need to evaluate it
				guard condition(frame) else {
					return
				}
				storage.send(frame)

			} else {
				storage.send(frame)
			}
		}

		return Color.clear
	}
}

public extension View {
    /// Stores the view frame anf origin in given coordinate space in provided storage.
    /// If condiiton is provided, storage will only be updated if condition evaluates to true.
	@available(*, deprecated, message: "deprecated, use storingSize with PassthroughSubject")
    func storingSize(
            in storage: Binding<CGRect>,
            space: CoordinateSpace = .local,
            when condition: ((CGRect)->Bool)? = nil,
            logToConsole: Bool = false
    ) -> some View {
        let color: (GeometryProxy) -> Color = { gr in
            DispatchQueue.main.async {
                let frame = gr.frame(in: space)
                guard storage.wrappedValue != frame else { return }
                #if DEBUG
                if logToConsole {
                    print("storing size for: \(frame)")
                }
                #endif

                if let condition = condition {
                    // condition is set, we need to evaluate it
                    guard condition(frame) else {
                        return
                    }
                    storage.wrappedValue = frame

                } else {
                    storage.wrappedValue = frame
                }
            }
            return Color.clear
        }

        return self.background(
                GeometryReader { gr in color(gr) }
        )
    }
    
    /// Stores the view frame and origin in given coordinate space in provided storage.
    /// If condition is provided, storage will only be updated if condition evaluates to true.
	@available(*, deprecated, message: "deprecated, use storingSize with PassthroughSubject")
    func storingSize(
            in storage: Binding<CGRect?>,
            space: CoordinateSpace = .local,
            when condition: ((CGRect)->Bool)? = nil,
            logToConsole: Bool = false
    ) -> some View {
        let color: (GeometryProxy) -> Color = { gr in
            DispatchQueue.main.async {
                let frame = gr.frame(in: space)

                #if DEBUG
                if logToConsole {
                    print("storing size for: \(frame)")
                }
                #endif

                guard storage.wrappedValue != frame else { return }
                if let condition = condition {
                    // condition is set, we need to evaluate it
                    guard condition(frame) else {
                        return
                    }
                    storage.wrappedValue = frame
                } else {
                    storage.wrappedValue = frame
                }
            }
            return Color.clear
        }

        return self.background(
                GeometryReader { gr in color(gr) }
        )
    }
}
