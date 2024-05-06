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
            .disabled(inProgress)
            .overlay(progressPlate(isOn: proxy.wrappedValue), alignment: .trailing)
            .animation(.easeInOut, value: proxy.wrappedValue)
    }

    @ViewBuilder
    private func progressPlate(isOn: Bool) -> some View {
        switch inProgress {
        case true:
            HStack {
                ProgressView {EmptyView()}
                    .padding(.horizontal, 56)
                    .tint(.gray)
            }

        case false:
            EmptyView()
        }
    }
}