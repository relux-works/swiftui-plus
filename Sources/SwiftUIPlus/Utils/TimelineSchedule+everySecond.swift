import SwiftUI

@available(iOS 15, macOS 12, *)
public extension TimelineSchedule where Self == PeriodicTimelineSchedule {
    static var everySecond: Self {
        .periodic(from: .now, by: 1)
    }
}
