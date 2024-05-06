/**
*  SwiftUIPageView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension View {
    
    /// Adds a condition that controls whether page views always use
    /// their provided alignment to position pages.
    ///
    /// - Parameters:
    ///   - strict: A Boolean value that determines whether page
    ///     views always use their provided alignment to position pages.
    func strictPageAlignment(_ strict: Bool = true) -> some View {
        environment(\.strictPageAlignment, strict)
    }
}

public extension View {
    
    /// no overview available
    /// - Parameters:
    func storingPageProxy(_ pageProxy: PageViewProxy, in pageProxyStorage: Binding<PageViewProxy?>) -> some View {
        DispatchQueue.main.async {
            pageProxyStorage.wrappedValue = pageProxy
        }
        return self
    }
}

