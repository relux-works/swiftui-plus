import SwiftUI

struct FixedTransactionTransition: ViewModifier {

    @Binding private var isPresentInParentContainer: Bool
	@Binding private var manualToggle: Bool
	@State private var isPresentInBody: Bool
    private let transition: AnyTransition
    private let animation: Animation

    init(
            isPresentInParentContainer: Binding<Bool>,
			manualToggle: Binding<Bool>,
            transition: AnyTransition,
            animation: Animation
    ) {
        self._isPresentInParentContainer = isPresentInParentContainer
		self._isPresentInBody = State(initialValue: false)
		self._manualToggle = manualToggle
        self.transition = transition
        self.animation = animation
    }

	func body(content: Content) -> some View {
		VStack(spacing: 0) {
			if isPresentInParentContainer, isPresentInBody, manualToggle {
				content
					.transition(transition)
					.transaction {
						$0.animation = animation
					}
			} else {
				// keeps layout intact
				content.opacity(0)
			}
		}
		.animation(animation, value: isPresentInBody)
		.animation(animation, value: isPresentInParentContainer)
		.onAppear {
			isPresentInBody = true
		}
	}
}

public extension View {

    /// A convenient way to apply transition to a view with advanced behavior that fixes certain edge cases (or bugs) of default SwiftUI transitions.
    /// - Parameter transition: a transition associated with a state-processing update. Do not apply animation within **this** parameter.
    /// - Parameter withAnimation: animation associated with a transition. Overrides any other animation associated with a transaction.
	/// - Parameter isPresentInBody: automatica toggle f
    /// - Parameter isPresentInParentContainer: advanced toggle that must provide a context of the current state-processing update. See discussion for more info.
	/// - Parameter manualToggle: allows manual control over view presence in hierarchy. Useful when it is necessary to remove the view with transition.

	///
    /// With the basic usage the modifier will just apply a provided transition with specified animation to a view.
    /// When you have a complex view-hierarchy with a branched structure which switches depending on context, and you need to provide transitions to specific elements
    /// within the branch, SwiftUI will animate the transition of the whole branch and will not propagate information about context switching deeper into hierarchy, i.e. views
    /// will not know they were out of active hierarchy and transitions will not occur.
    ///
    /// To fix this behavior, switch the branch within an animation block and toggle a proxy properly that holds a boolean information about branch presence in active
    /// view-hierarchy. It's important to switch branches within an animation block **and** pass the proxy as a binding, otherwise SwiftUI will lose the context associated with the transition
    /// and it will not be applied properly.
    ///
    ///     @State private var branchAProxy = false
    ///     @State private var branchBProxy = false
    ///     var body: some View {
    ///         VStack(spacing: 0) {
    ///             switch currentBranch {
    ///             case .branchA:
    ///                 ViewHierarchyA(isPresentInParentContainer: $branchAProxy)
    ///             case .branchB:
    ///                 ViewHierarchyB(isPresentInParentContainer: $branchBProxy)
    ///             }
    ///         }
    ///         .onAppear {
    ///             setBranch(.branchA, animation: .linear)
    ///         }
    ///     }
    ///
    ///     private func setBranch(_ branch: Branch, animation: Animation) {
    ///         withAnimation(animation) {
    ///             self.currentBranch = branchpage
    ///             self.branchAProxy = (branch == .branchA)
    ///             self.branchBProxy = (page == .branchB)
    ///         }
    ///      }
    ///
    ///      // within ViewHierarchyA / ViewHierarchyB apply this modifier to individual elements
    ///
    func transition(
            _ transition: AnyTransition,
            withAnimation animation: Animation = .default,
            isPresentInParentContainer : Binding<Bool> = .constant(true),
			manualToggle: Binding<Bool> = .constant(true)
    ) -> some View {
        self.modifier(
                FixedTransactionTransition(
                        isPresentInParentContainer: isPresentInParentContainer,
						manualToggle: manualToggle,
                        transition: transition,
                        animation: animation
                )
        )
    }
}
