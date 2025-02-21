// Copyright (c) 2021-2025 Alexey Grigorev, Ivan Oparin
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Combine
import Foundation

/// Manages scroll-driven visual effects for UI elements, such as opacity and color transitions.
///
/// This class observes scroll position changes via `contentFrame` and publishes updates to properties like
/// `navigationBarBackgroundOpacity` and `textColorTransitionProgress`. It’s designed for use in SwiftUI views
/// to create dynamic effects based on user scrolling.
///
/// - Example:
///   ```swift
///   struct ContentView: View {
///       @StateObject private var scrollEffects = ScrollDrivenVisualEffects()
///
///       var body: some View {
///           ScrollView {
///               Text("Scroll me")
///                   .foregroundColor(Color(
///                       red: 1.0 - scrollEffects.textColorTransitionProgress,
///                       green: 1.0 - scrollEffects.textColorTransitionProgress,
///                       blue: 1.0 - scrollEffects.textColorTransitionProgress
///                   ))
///                   .frame(maxWidth: .infinity)
///                   .padding()
///                   .background(GeometryReader { geometry in
///                       Color.clear.onChange(of: geometry.frame(in: .named(scrollEffects.contentSpaceIdentifier))) { frame in
///                           scrollEffects.contentFrame = frame
///                       }
///                   })
///           }
///           .coordinateSpace(name: scrollEffects.contentSpaceIdentifier)
///       }
///   }
///   ```
final class ScrollDrivenVisualEffects: ObservableObject {
    // MARK: - Properties
    
    private var pipelines: Set<AnyCancellable> = []
    private let appearanceTimer = Timer.publish(every: 2, on: .main, in: .common)
    
    /// Indicates whether the appearance transition has completed.
    @Published var hasAppearanceTransitionCompleted = false
    
    /// The frame of the content view, used to determine scroll position.
    @Published var contentFrame: CGRect = .zero
    
    /// Opacity of the navigation bar background, ranging from 0 to 1.
    @Published var navigationBarBackgroundOpacity: CGFloat = 0.0
    
    /// Progress of text color transition from white (0.0) to black (1.0).
    @Published var textColorTransitionProgress: CGFloat = 0.0
    
    /// Identifier for the content space coordinate system.
    let contentSpaceIdentifier = "ContentSpaceId"
    
    // MARK: - Computed Properties
    
    /// Whether the view is in the process of disappearing.
    var isDisappearing: Bool {
        hasAppearanceTransitionCompleted
    }
    
    /// Whether the view is in the process of appearing.
    var isAppearing: Bool {
        !hasAppearanceTransitionCompleted
    }
    
    // MARK: - Initialization
    
    init() {
        setupPipelines()
    }
    
    // MARK: - Pipeline Setup
    
    /// Configures all reactive pipelines for appearance updates.
    private func setupPipelines() {
        setupAppearanceTransitionPipeline()
        setupNavigationBarOpacityPipeline()
        setupTextColorTransitionPipeline()
    }
    
    /// Sets up the pipeline for appearance transition completion.
    private func setupAppearanceTransitionPipeline() {
        appearanceTimer
            .autoconnect()
            .map { _ in true }
            .removeDuplicates()
            .assign(to: &$hasAppearanceTransitionCompleted)
    }
    
    /// Sets up the pipeline for navigation bar background opacity based on scroll position.
    private func setupNavigationBarOpacityPipeline() {
        $contentFrame
            .map { frame in
                frame.origin.y <= 0 ? min((1.0 / 10.0) * abs(frame.origin.y), 1.0) : 0.0
            }
            .assign(to: &$navigationBarBackgroundOpacity)
    }
    
    /// Sets up the pipeline for text color transition progress.
    private func setupTextColorTransitionPipeline() {
        $contentFrame
            .map { frame in
                if frame.origin.y >= 0 {
                    return 0.0
                } else {
                    let pullDistance = abs(frame.origin.y)
                    let normalizedPull = min(pullDistance / 50.0, 1.0)
                    let baseProgress = pow(normalizedPull, 4.0)
                    let progress = 0.2 + (0.8 * baseProgress)
                    return progress
                }
            }
            .removeDuplicates()
            .assign(to: &$textColorTransitionProgress)
    }
}
