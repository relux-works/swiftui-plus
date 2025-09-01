import SwiftUI

extension View {
    public var keyboardDismissOverlay: some View {
        self.modifier(KeyboardDismissOverlayModifier())
    }
    public var keyboardDismissOverlayForLists: some View {
        self.modifier(KeyboardDismissOverlayForListsModifier())
    }
}

struct KeyboardDismissOverlayForListsModifier: ViewModifier {
    @Environment(\.dismissKeyboard) private var dismissKeyboard
    @Environment(\.bounds) private var bounds
    @StateObject private var ls: KeyboardDismissOverlayModifier.LS = .init()
    @StateObject private var keyboardObserver: KeyboardObserver = .init()

    func body(content: Content) -> some View {
        content
            .environmentObject(ls)
            .overlay(tapHandler)
    }

    @ViewBuilder
    private var tapHandler: some View {
        switch keyboardObserver.shown && ls.frames.isEmpty.not {
        case true:
            ZStack(alignment: .top) {
                Rectangle()
                    .frame(height: highestFrame.origin.y)
                Rectangle()
                    .padding(.top, lowestFrame.origin.y + lowestFrame.height)
            }
                .foregroundColor(.white.opacity(0.005))
                .ignoresSafeArea()
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { _ in
                            print(">>>> dismiss keyboard")
                            dismissKeyboard()
                        }
                )

        case false:
            EmptyView()
        }
    }

    private var highestFrame: CGRect {
        ls.frames.min{ $0.rect.origin.y < $1.rect.origin.y }?.rect ?? .zero
    }

    private var lowestFrame: CGRect {
        ls.frames.max{ $0.rect.origin.y < $1.rect.origin.y }?.rect ?? .zero
    }
}

struct KeyboardDismissOverlayModifier: ViewModifier {
    @StateObject private var ls: LS = .init()
    @Environment(\.dismissKeyboard) private var dismissKeyboard
    @StateObject private var keyboardObserver: KeyboardObserver = .init()

    func body(content: Content) -> some View {
        content
            .environmentObject(ls)
            .overlay(tapHandler)
//            .simultaneousGesture(
//                keyboardObserver.shown
//                    ? DragGesture(minimumDistance: 0, coordinateSpace: .global).onEnded{ ctx in checkDismissKeyboard(ctx.location)}
//                    : nil
//            )
    }

    private func checkDismissKeyboard(_ point: CGPoint) {
        let containedInExclusions = ls.frames
            .contains {
                let res = $0.rect.contains(point)
                print(">>> rect: \($0) point: \(point) contains: \(res)")
                return res
            }


        switch containedInExclusions {
        case true: break
        case false: dismissKeyboard()
        }
    }

    @ViewBuilder
    private var tapHandler: some View {
        switch keyboardObserver.shown {
        case true:
            OverlayShape(holes: $ls.frames)
                .foregroundColor(.white.opacity(0.005))
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { _ in dismissKeyboard() }
                )

        case false:
            EmptyView()
        }
    }
}
