import SwiftUI

public extension GenericPicker {
    struct Item: Identifiable {
        public typealias Id = String
        public let id: Id
        let disabled: Bool
        let content : ()-> any View

        public init(id: Id, disabled: Bool = false, content: @escaping () -> any View) {
            self.id = id
            self.disabled = disabled
            self.content = content
        }
    }
}

public struct GenericPicker: View {
    @Binding private var selected: Item.Id?
    private let items: [Item]
    private let deselectionAllowed: Bool

    public init(
        selected: Binding<Item.Id?> = .constant(nil),
        items: [Item],
        deselectionAllowed: Bool = false
    ) {
        self._selected = selected
        self.items = items
        self.deselectionAllowed = deselectionAllowed
    }
    
    public var body: some View {
        content
            .animation(.linear, value: selected)
    }

    @ViewBuilder
    private var content: some View {
        ForEach(items) { item in
            Button(action: { onTap(item.id) }) {
                itemContent(item)
            }.disabled(item.disabled)
        }
    }

    @ViewBuilder
    private func itemContent(_ item: Item) -> some View {
        item.content()
            .asAnyView
    }

    private func onTap(_ itemId: Item.Id) {
        switch selected == itemId {
            case true:
                switch deselectionAllowed {
                    case true: selected = .none
                    case false: break
                }
            case false:
                selected = itemId
        }
    }
}
