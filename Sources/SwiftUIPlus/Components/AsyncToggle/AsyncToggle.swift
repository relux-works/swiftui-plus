import SwiftUI

public struct AsyncToggle<Label: View>: View {
    @Binding private var isOn: Bool
    private let onChange: (Bool)async->()
    @ViewBuilder private let label: ()->Label
    @State private var inProgress: Bool = false

    public init(
            isOn: Binding<Bool>,
            onChange: @escaping (Bool)async->(),
            @ViewBuilder label: @escaping ()->Label
    ) {
        self._isOn = isOn
        self.onChange = onChange
        self.label = label
    }

    public var body: some View {
        let proxy = Binding<Bool>(
                get: { isOn },
                set: { toggle in
                    inProgress = true
                    Task {
                        await onChange(toggle)
                        inProgress = false
                    }
                }
        )

        Toggle(isOn: proxy, label: label)
                .overlay(progressPlate, alignment: .trailing)
    }

    @ViewBuilder
    private var progressPlate: some View {
        switch inProgress {
        case true:
            ProgressView {EmptyView()}
                    .padding(.horizontal)
        case false:
            EmptyView()
        }
    }
}