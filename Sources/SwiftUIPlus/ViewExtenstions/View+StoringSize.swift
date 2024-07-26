// https://github.com/ivalx1s/swift-stdlibplus/
// MIT License
//
// Copyright (c) 2021 Alexey Grigorev, Ivan Oparin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SwiftUI
import Combine
import Foundation

public extension View {
    func storingSize(
        in storage: PassthroughSubject<CGRect, Never>,
        onQueue queue: DispatchQueue = DispatchQueue.main,
        space: CoordinateSpace = .local,
        when condition: ((CGRect)->Bool)? = nil,
        logToConsole: Bool = false
    ) -> some View {
        self.modifier(ViewFrameReader(storage: storage, onQueue: queue, coordinateSpace: space, when: condition, logToConsole: logToConsole) )
    }
}

extension ViewFrameReader {
    @MainActor
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
        ls.queue.sync { [weak storage] in
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
                storage?.send(frame)

            } else {
                storage?.send(frame)
            }
        }
        return Color.clear
    }
}
