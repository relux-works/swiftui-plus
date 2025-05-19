import SwiftUI

extension FpsMonitorModifier {
    @MainActor
    final class LS: ObservableObject {
        private var lock: NSLock = .init()
        nonisolated(unsafe) private var displayLink: CADisplayLink?
        private var getTimestamp: CFTimeInterval { CACurrentMediaTime() }
        private var lastTimestamp: CFTimeInterval?
        private var frameCount: Double = 0
        private var minimalTimeInterval: CFTimeInterval = 1

        @Published private(set) var fpsCount: Double = 0

        init() {
            let displayLink = CADisplayLink(target: self, selector: #selector(self.onTick))
            displayLink.add(to: .main, forMode: .common)

            lock.withLock {
                self.displayLink = displayLink
            }
        }

        deinit {
            lock.withLock {
                self.displayLink?.invalidate()
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
    }
}
