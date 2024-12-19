import SwiftUI

public final class ParentResolverViewController: UIViewController {
    private let onResolve: VCResolveHandler?
    private let onAppearanceChange: VCAppearanceHandler?

    public init(
            onResolve: VCResolveHandler? = nil,
            onAppearanceChange:  VCAppearanceHandler? = nil
    ) {
        self.onResolve = onResolve
        self.onAppearanceChange = onAppearanceChange
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(onResolve:) to instantiate ParentResolverViewController.")
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Task {@MainActor [weak self] in
            guard let self else { return }
            await self.onAppearanceChange?(self, .willDisappear)
        }
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {@MainActor [weak self] in
            guard let self else { return }
            await self.onAppearanceChange?(self, .didAppear)
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {@MainActor [weak self] in
            guard let self else { return }
            await self.onAppearanceChange?(self, .willAppear)
        }
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Task {@MainActor [weak self] in
            guard let self else { return }
            await self.onAppearanceChange?(self, .didDisappear)
        }
    }


    override public func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        Task {@MainActor [weak self, weak parent] in
            guard let self, let parent else { return }
            guard  let parent = self.parent else { return }
            await self.onResolve?(parent)
        }
    }
}
