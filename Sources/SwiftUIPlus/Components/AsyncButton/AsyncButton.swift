import SwiftUI

public struct TabViewItemButtonStyle: ButtonStyle {
	public init() { }
	public func makeBody(configuration: Configuration) -> some View {
		configuration.label
	}
}

public struct AsyncButton<Label: View>: View {
    private let actionPriority: TaskPriority?
    private let actionOptions: Set<AsyncButton<Label>.ActionOption>
    private let role: ButtonRole?
    let action: () async -> Void
	
	@State private var isDisabled = false
	@State private var showProgress = false
	@ViewBuilder let label: Label
    
    public init(
        actionPriority: TaskPriority? = nil,
        actionOptions: Set<AsyncButton<Label>.ActionOption> = [ActionOption.disableButton],
        role: ButtonRole? = .none,
        action: @escaping () async -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.actionPriority = actionPriority
        self.actionOptions = actionOptions
        self.role = role
        self.action = action
        self.label = label()
    }
    
	public var body: some View {
		Button(role: role, action: customizedAction) {
			label
				.opacity(showProgress ? 0 : 1)
				.overlay(progressView)
		}
		.disabled(isDisabled)
	}

    @ViewBuilder
    private var progressView: some View {
        switch showProgress {
        case true: ProgressView()
        case false: EmptyView()
        }
    }

    private func customizedAction() {
        if actionOptions.contains(.disableButton) {
            isDisabled = true
        }

        Task(priority: actionPriority) {
            var progressViewTask: Task<Void, Error>?

            if actionOptions.contains(.showProgressView) {
                progressViewTask = Task {
                    try await Task.sleep(nanoseconds: 150_000_000)
                    showProgress = true
                }
            }

            await action()
            progressViewTask?.cancel()

            isDisabled = false
            showProgress = false
        }
    }
}

public extension AsyncButton where Label == Text {
    init(_ label: String,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void) {
        
        self.init(action: action) {
            Text(label)
        }
    }
}

public extension AsyncButton where Label == Image {
    init(systemImageName: String,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void) {
        self.init(action: action) {
            Image(systemName: systemImageName)
        }
    }
}

public extension AsyncButton {
    enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
    }
}
