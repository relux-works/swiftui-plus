import SwiftUI

public struct StoriesPager<Model, Page, SwitchModifier>: View
    where Model: Identifiable & Hashable, Page: View, SwitchModifier: ViewModifier {

    @Binding private var current: Model
    private let models: [Model]
    private let storyBuilder: (Model) -> Page
    private let switchStoryModifier: SwitchModifier
    private let pages: [Model: Page]

    public init(
        current: Binding<Model>,
        models: [Model],
        @ViewBuilder storyViewBuilder: @escaping (Model) -> Page,
        switchStoryModifier: SwitchModifier = CubeRotationModifier()
    ) {
        self._current = current
        self.models = models
        self.storyBuilder = storyViewBuilder
        self.switchStoryModifier = switchStoryModifier
        self.pages = models.reduce(into: [Model: Page]()) { store, next in store[next] = storyViewBuilder(next)}
    }

    public var body: some View {
        TabView(selection: $current) {
            ForEach(models) { model in
                pages[model]
                    .tag(model)
                    .modifier(switchStoryModifier)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}
