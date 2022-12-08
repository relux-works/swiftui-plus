import SwiftUI


@available(iOS 15, macOS 12, *)
public struct AdaptiveStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    public typealias ConditionHandler = (UserInterfaceSizeClass?, DynamicTypeSize) -> Bool
    private let condition: ConditionHandler
    private let content: Content
    
    private let horizontalAlignment: HorizontalAlignment
    private let horizontalSpacing: CGFloat?
    private let verticalAlignment: VerticalAlignment
    private let verticalSpacing: CGFloat?
    
    // ⚠️
    #warning("⚠️ add documentation")
    public init(horizontalAlignment: HorizontalAlignment = .center,
                horizontalSpacing: CGFloat? = nil,
                verticalAlignment: VerticalAlignment = .center,
                verticalSpacing: CGFloat? = nil,
                condition: @escaping ConditionHandler,
                @ViewBuilder content: () -> Content) {
        self.horizontalAlignment = horizontalAlignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalAlignment = verticalAlignment
        self.verticalSpacing = verticalSpacing
        self.condition = condition
        self.content = content()
    }
    
#warning("⚠️ add documentation")
    // convinence initializer for common conditions
    public init(
        horizontalAlignment: HorizontalAlignment = .center,
        horizontalSpacing: CGFloat? = nil,
        verticalAlignment: VerticalAlignment = .center,
        verticalSpacing: CGFloat? = nil,
        condition: Condition,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            horizontalAlignment: horizontalAlignment,
            horizontalSpacing: horizontalSpacing,
            verticalAlignment: verticalAlignment,
            verticalSpacing: verticalSpacing,
            condition: AdaptiveStack.handler(condition),
            content: content
        )
    }
    
    public var body: some View {
        if condition(horizontalSizeClass, dynamicTypeSize) {
            VStack(
                alignment: horizontalAlignment,
                spacing: verticalSpacing
            ) {
                content
            }
        } else {
            HStack(
                alignment: verticalAlignment,
                spacing: horizontalSpacing
            ) {
                content
            }
        }
    }
}

@available(iOS 15, macOS 12, *)
public extension AdaptiveStack {
    
    enum Condition {
      case compact
      case regular
      case accessible
      case accessibleLarger2
      case accessibleLarger4
      case compactAccessible
      case regularAccessible
    }

    static private func handler(_ condition: Condition) -> ConditionHandler {
      switch condition {
      case .compact: return compact
      case .regular: return regular
      case .accessible: return accessible
      case .accessibleLarger2: return accessibleLarger2
      case .accessibleLarger4: return accessibleLarger4
      case .compactAccessible: return compactAccessible
      case .regularAccessible: return regularAccessible
      }
    }
    
    static private func compact(horizontalSizeClass: UserInterfaceSizeClass?, dynamicTypeSize: DynamicTypeSize) -> Bool {
      horizontalSizeClass == .compact
    }

    static private func regular(horizontalSizeClass: UserInterfaceSizeClass?, dynamicTypeSize: DynamicTypeSize) -> Bool {
      horizontalSizeClass == .regular
    }

    static private func accessible(horizontalSizeClass: UserInterfaceSizeClass?, dynamicTypeSize: DynamicTypeSize) -> Bool {
      dynamicTypeSize.isAccessibilitySize
    }
    
    static private func accessibleLarger2(horizontalSizeClass: UserInterfaceSizeClass?, dynamicTypeSize: DynamicTypeSize) -> Bool {
        DynamicTypeSize.largerAccessibility2Sizes.contains(dynamicTypeSize)
    }
    
    static private func accessibleLarger4(horizontalSizeClass: UserInterfaceSizeClass?, dynamicTypeSize: DynamicTypeSize) -> Bool {
        DynamicTypeSize.largerAccessibility2Sizes.contains(dynamicTypeSize)
    }

    static private func compactAccessible(horizontalSizeClass: UserInterfaceSizeClass?, dynamicTypeSize: DynamicTypeSize) -> Bool {
      horizontalSizeClass == .compact &&
      dynamicTypeSize.isAccessibilitySize
    }

    static private func regularAccessible(horizontalSizeClass: UserInterfaceSizeClass?, dynamicTypeSize: DynamicTypeSize) -> Bool {
      horizontalSizeClass == .regular &&
      dynamicTypeSize.isAccessibilitySize
    }
}

@available(iOS 15, macOS 12, *)
public extension DynamicTypeSize {
    static var largerAccessibility2Sizes: Set<Self> {
        .init(arrayLiteral: .accessibility2, .accessibility3, .accessibility4, .accessibility5)
    }
    
    static var largerAccessibility4Sizes: Set<Self> {
        .init(arrayLiteral: .accessibility4, .accessibility5)
    }
}




