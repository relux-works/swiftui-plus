import SwiftUI

public struct StoriesPager<Model, Page, SwitchModifier>: View
    where Model: Identifiable & Hashable, Page: View, SwitchModifier: ViewModifier {
    
    @Environment(\.bounds) private var bounds
    @State private var contentPressed = false

    @Binding private var current: Model

    private let models: [Model]
    private let pages: [Model: Page]

    private let viewConfig: ViewConfig
    private let reactions: Reactions?

    public init(
        current: Binding<Model>,
        models: [Model],
        viewConfig: ViewConfig,
        reactions: Reactions? = .none
    ) {
        self._current = current
        self.models = models
        self.viewConfig = viewConfig
        self.reactions = reactions

        self.pages = models.reduce(into: [Model: Page]()) { store, next in store[next] = viewConfig.storyViewBuilder(next)}
    }

    public var body: some View {
        TabView(selection: $current) {
            ForEach(models) { model in
                Button(action: {}) {
                    if #available(iOS 16.0, *) {
                        pages[model]
                            .tag(model)
                            .modifier(viewConfig.switchStoryModifier)
                            .onTapGesture(perform: onTapContent)
                    } else {
                        pages[model]
                            .tag(model)
                            .modifier(viewConfig.switchStoryModifier)
                    }
                }
                .buttonStyle(
                    PressHandleButtonStyle(props: .init(
                        pressConfig: viewConfig.contentOnHoldConfig,
                        minDuration: viewConfig.contentOnHoldMinDuration,
                        reaction: (
                            onPress: { reactOnHoldContent(true) },
                            onRelease: { reactOnHoldContent(false) }
                        )
                    ))
                )
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

// reactions
extension StoriesPager {
    private func reactOnBack() {
        print("\(#file) \(#function)")
    }

    private func reactOnForward() {
        print("\(#file) \(#function)")
    }

    private func onTapContent(_ location: CGPoint) {
        guard contentPressed.not else { return }
        switch location.x < viewConfig.backToForwardAreaRatio * bounds.width {
            case true: reactOnBack()
            case false: reactOnForward()
        }
    }

    private func reactOnHoldContent(_ presed: Bool) {
        print("\(#file) \(#function) : \(presed)")
        self.contentPressed = presed
    }
}
