import SwiftUI

public protocol IStoryModel: Identifiable {
    associatedtype Id: Hashable
    var id: Id { get }
}

public struct StoriesPager<Model, Page, SwitchModifier>: View
    where Model: IStoryModel, Page: View, SwitchModifier: ViewModifier {

    @Environment(\.bounds) private var bounds
    @StateObject private var ls: LocalState
    @Binding private var currentId: Model.Id
    @Binding private var activeId: Model.Id?

    private let models: [Model]
    private let pages: [Model.Id: Page]

    private let viewConfig: ViewConfig
    private let reactions: Reactions?
    private let coordinateSpace: String = "StoriesPager \(UUID().uuidString)"

    public init(
        currentId: Binding<Model.Id>,
        activeId: Binding<Model.Id?> = .constant(.none),
        models: [Model],
        viewConfig: ViewConfig,
        reactions: Reactions? = .none
    ) {
        self._currentId = currentId
        self._activeId = activeId
        self.models = models
        self.viewConfig = viewConfig
        self.reactions = reactions

        self.pages = models
            .reduce(into: [Model.Id: Page]()) { store, next in
                store[next.id] = viewConfig.storyViewBuilder(next)
            }

        self._ls = .init(wrappedValue: .init(viewConfig: viewConfig))
    }

    public var body: some View {
        content
            .coordinateSpace(name: coordinateSpace)
            .animation(.linear, value: currentId)
            .onReceive(ls.navigationPub) { self.reactions?.navigationSubject?.send($0) }
            .onReceive(ls.activePageIdPub.removeDuplicates()) { self.activeId = $0 }
            .onChange(of: currentId) { new in
                print(">>> stories pager currentId change: to \(new)")
            }
    }

    @ViewBuilder
    private var content: some View {
        if #available(iOS 17.0, *) {
            scrollViewPageContent
                .onReceive(ls.activePageIdPub.removeDuplicates()) { active in
                    print(">>> stories pager activeId pub: \(active)")
                    guard let active, active != currentId else { return }
                    self.currentId = active
                }
        } else {
            tabViewPagesContent
        }
    }

    @available(iOS 17, *)
    private var scrollViewPageContent: some View {
        Button(action: {}) {
            ScrollViewReader { sr in
                scrollviewPager
                    .onAppear {
                        ls.delayForAnimation()
                        Task { @MainActor in
                            sr.scrollTo(currentId)
                        }
                    }
                    .onChange(of: currentId) { id in
                        ls.delayForAnimation()
                        Task { @MainActor in
                            withAnimation(.linear) { sr.scrollTo(id) }
                        }
                    }
                    .onTapGesture {
                        ls.delayForAnimation()
                        onTapContent(location: $0, activeId: currentId, triggeredId: currentId)
                    }
            }
            .transaction{ $0.animation = .none }
        }
        .buttonStyle(
            PressHandleButtonStyle(props: .init(
                pressed: reactions?.contentHeld ?? .constant(false),
                pressConfig: viewConfig.contentOnHoldConfig,
                minDuration: viewConfig.contentOnHoldMinDuration
            ))
        )
    }

    @available(iOS 17, *)
    private var scrollviewPager: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(models) { model in
                        pages[model.id]
                            .frame(width: bounds.width)
                            .containerRelativeFrame([.horizontal])
                            .modifyWithCubeRotation
                            .id(model.id)
                    }
                }.background {
                    Color.clear
                        .frameOnChange(space: .named(coordinateSpace)) { rect in
                            ls.onContentFrameChange(rect, bounds: self.bounds, models: self.models)
                        }
                }
        }
        .scrollTargetBehavior(.paging)
        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
        .scrollClipDisabled()
    }

    private var tabViewPagesContent: some View {
        TabView(selection: $currentId) {
            ForEach(models) { model in
                pageContent(model)
                    .tag(model.id)
                    .modifier(viewConfig.switchStoryModifier)
                    .frameOnChange(space: .named(coordinateSpace)) { rect in
                        ls.trackPageRects(currentPageId: currentId, targetPageId: model.id, rect: rect)
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    private func pageContent(_ model: Model) -> some View {
        Button(action: {}) {
            Group {
                if #available(iOS 16.0, *) {
                    pages[model.id]
                        .onTapGesture { onTapContent(location: $0, activeId: currentId, triggeredId: model.id) }
                }
                else {
                    pages[model.id]
                        .onTapGesture { reactOnForward(activeId: currentId,triggeredId: model.id) }
                }
            }
            .transaction { $0.animation = .none } // removes default animations inherited from modals
        }
            .buttonStyle(
                PressHandleButtonStyle(props: .init(
                    pressed: reactions?.contentHeld ?? .constant(false),
                    pressConfig: viewConfig.contentOnHoldConfig,
                    minDuration: viewConfig.contentOnHoldMinDuration
                ))
            )
    }
}

// reactions
extension StoriesPager {
    private func reactOnBack(activeId: Model.Id, triggeredId: Model.Id) {
        guard ableToHandleNavigation(active: activeId, triggered: triggeredId, contentHeld: reactions?.contentHeld)
        else { return }
        self.ls.navigationSub.send(.backward(from: triggeredId))
    }

    private func reactOnForward(activeId: Model.Id, triggeredId: Model.Id) {
        guard ableToHandleNavigation(active: activeId, triggered: triggeredId, contentHeld: reactions?.contentHeld)
        else { return }
        self.ls.navigationSub.send(.forward(from: triggeredId))
    }

    private func ableToHandleNavigation(active: Model.Id, triggered: Model.Id, contentHeld: Binding<Bool>?) -> Bool {
        guard let flag = contentHeld?.wrappedValue,
              flag.not 
        else {
            print(">>>> handle tap while on hold: active: \(active), triggered: \(triggered)")
            return false
        }

        guard active == triggered
        else {
            print(">>>> unordinary switch try: active: \(active), triggered: \(triggered)")
            self.currentId = triggered // recovery mode
            return false
        }

        if #unavailable(iOS 17) {
            guard let rect = ls.pagesRects[triggered],
                  rect.origin.x == 0
            else {
                print(">>>> handle tap while animation xOffset: \(ls.pagesRects[triggered]?.minX.description ?? "NaN"): active: \(active), triggered: \(triggered)")
                return false
            }
        }

        return true
    }

    private func onTapContent(location: CGPoint, activeId: Model.Id, triggeredId: Model.Id) {
        switch location.x < viewConfig.backToForwardAreaRatio * bounds.width {
            case true: reactOnBack(activeId: activeId, triggeredId: triggeredId)
            case false: reactOnForward(activeId: activeId, triggeredId: triggeredId)
        }
    }
}
