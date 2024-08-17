import SwiftUI

public struct StoriesPager<T, Content, SwitchModifier>: View
    where T: Identifiable & Hashable, Content: View, SwitchModifier: ViewModifier {

    @Binding private var current: T
    private let models: [T]
    private let storyBuilder: (T) -> Content
    private let switchStoryModifier: SwitchModifier

    public init(
        current: Binding<T>,
        models: [T],
        @ViewBuilder storyViewBuilder: @escaping (T) -> Content,
        switchStoryModifier: SwitchModifier = CubeRotationModifier()
    ) {
        self._current = current
        self.models = models
        self.storyBuilder = storyViewBuilder
        self.switchStoryModifier = switchStoryModifier
    }

    public var body: some View {
        TabView(selection: $current) {
            ForEach(models) { model in
                storyBuilder(model)
                    .tag(model)
                    .modifier(switchStoryModifier)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}
