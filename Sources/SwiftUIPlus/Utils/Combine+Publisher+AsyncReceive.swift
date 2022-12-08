import Combine

extension View {
    @inlinable public func onReceive<P>(
            _ publisher: P,
            priority: _Concurrency.TaskPriority = .userInitiated,
            @_inheritActorContext perform action: @escaping @Sendable (P.Output) async -> Void
    ) -> some View where P : Publisher, P.Failure == Never {
        onReceive(
                publisher,
                perform: { output in
                    Task(priority: priority) { await action(output) }
                }
        )
    }
}