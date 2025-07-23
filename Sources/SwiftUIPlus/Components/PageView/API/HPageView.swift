/**
*  SwiftUIPageView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// A view that arranges its children in a horizontal line, and provides
/// paged scrolling behaviour.
public struct HPageView<Content>: View where Content: View {
	
	@usableFromInline
	let alignment: PageAlignment<HorizontalPageAlignment, VerticalAlignment>
	
	@usableFromInline
	let pageWidth: CGFloat?
	
	@usableFromInline
	let spacing: CGFloat?
	
	@usableFromInline
	let activePageIndex: Binding<Int?>?
    
    @usableFromInline
    let defaultMinimumDistance: CGFloat
	
	@usableFromInline
	@ViewBuilder let content: () -> Content
	
	public var body: some View {
		
		PageView(
			alignment: alignment.alignment,
			axis: .horizontal,
			content: content,
			pageLength: pageWidth,
			spacing: spacing,
            defaultMinimumDistance: defaultMinimumDistance,
            activePageIndex: activePageIndex
		)
		
	}
    
    /// A view that arranges its children in a horizontal line, and provides
    /// paged scrolling behaviour.
    ///
    /// This view returns a flexible preferred size to its parent layout.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the pages in this page view.
    ///   - pageWidth: The width of each page, or `nil` if you want each
    ///     page to fill the width of the page view.
    ///   - spacing: The distance between adjacent pages, or `nil` if you
    ///     want the page view to choose a default distance for each pair of
    ///     pages.
    ///   - content: A view builder that creates the content of this page view.
	@inlinable
    public init(alignment: PageAlignment<HorizontalPageAlignment, VerticalAlignment> = .center,
                pageWidth: CGFloat? = nil,
                spacing: CGFloat? = nil,
                activePageIndex: Binding<Int?>? = nil,
                defaultMinimumDistance: CGFloat = 15,
                @ViewBuilder content: @escaping () -> Content)
    {
		self.alignment = alignment
		self.pageWidth = pageWidth
		self.spacing = spacing
		self.activePageIndex = activePageIndex
        self.defaultMinimumDistance = defaultMinimumDistance
		self.content = content
    }
}
