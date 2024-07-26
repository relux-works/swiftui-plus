import SwiftUI
import Combine

extension View {
    public var adaptsToSoftwareKeyboard: some View {
        self
            .modifier(AdaptsToSoftwareKeyboard())
    }
}

extension AdaptsToSoftwareKeyboard {
    final class LocalState: ObservableObject {
        @Published private(set) var keyboardHeight: CGFloat = 0

        func subscribeToKeyboardEvents() {
            Publishers
                .Merge(keyboardWillOpen, keyboardWillHide)
                .subscribe(on: RunLoop.main)
                .assign(to: &$keyboardHeight)
        }

        private let keyboardWillOpen = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0?.height ?? 0}

        private let keyboardWillHide =  NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat.zero }
    }
}
struct AdaptsToSoftwareKeyboard: ViewModifier {
    @Environment(\.safeAreaEdgeInsets) private var insets
    @StateObject private var ls: LocalState = .init()

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if ls.keyboardHeight > 0 {
                Spacer()
            }
            content
        }
            .padding(.bottom, max(ls.keyboardHeight - insets.bottom, 0))
            .animation (.easeInOut, value: ls.keyboardHeight)
            .ignoresSafeArea(.keyboard)
            .onAppear(perform: ls.subscribeToKeyboardEvents)
    }
}

final class KeyboardResponder: ObservableObject {
    private var _center: NotificationCenter
    private var delta: CGFloat
    @Published var currentHeight: CGFloat = 0

    init(delta: CGFloat = 0, center: NotificationCenter = .default) {
        self.delta = delta
        _center = center
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size.height {
            currentHeight = height + delta
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}

