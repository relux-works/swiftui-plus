import SwiftUI

extension FpsMonitorModifier.LS {
    enum Highlight {
        case none, extremelyLow, low, medium, high
    }
}
extension FpsMonitorModifier.LS.Highlight {
    var associatedColor: Color {
        switch self {
            case .none: .gray
            case .extremelyLow: .red
            case .low: .orange
            case .medium: .yellow
            case .high: .green
        }
    }
}

extension FpsMonitorModifier {
    @MainActor
    final class LS: ObservableObject {
        private var lock: NSLock = .init()
        nonisolated(unsafe) private var displayLink: CADisplayLink?
        private var getTimestamp: CFTimeInterval { CACurrentMediaTime() }
        private var lastTimestamp: CFTimeInterval?
        private var frameCount: Double = 0
        private var minimalTimeInterval: CFTimeInterval

        @Published private(set) var highlight: Highlight = .none
        @Published private(set) var fpsCount: Double = 0

        init(props: Props) {
            self.minimalTimeInterval = props.minTimeInterval
            setupDisplayLink()
            initPipelines()
        }

        deinit {
            lock.withLock {
                self.displayLink?.invalidate()
            }
        }

        private func setupDisplayLink() {
            let displayLink = CADisplayLink(target: self, selector: #selector(self.onTick))
            displayLink.add(to: .main, forMode: .common)

            lock.withLock {
                self.displayLink = displayLink
            }
        }

        @objc
        private func onTick() {
            switch self.lastTimestamp {
                case .none:
                    self.lastTimestamp = self.getTimestamp
                case let .some(lastTimestamp):
                    let current = self.getTimestamp
                    self.frameCount += 1
                    let timeLapse = current - lastTimestamp

                    guard timeLapse >= self.minimalTimeInterval
                    else { return }

                    let fps = frameCount / timeLapse
                    self.resetCounter(with: current)
                    self.onUpdate(fps)
            }
        }

        private func resetCounter(with newTs: CFTimeInterval) {
            self.frameCount = 0
            self.lastTimestamp = newTs
        }

        private func onUpdate(_ fps: Double) {
            self.fpsCount = fps
        }

        private func initPipelines() {
            $fpsCount
                .map {
                    switch $0 {
                        case 50...: Highlight.high
                        case 40...50: Highlight.medium
                        case 30...40: Highlight.low
                        case 1...30: Highlight.extremelyLow
                        default: Highlight.none
                    }
                }
                .assign(to: &$highlight)
        }
    }
}
