// FineTune/Views/Components/ExpandableGlassRow.swift
import SwiftUI

/// A reusable expandable row with unified Liquid Glass styling
struct ExpandableGlassRow<Header: View, ExpandedContent: View>: View {
    let isExpanded: Bool
    @ViewBuilder let header: () -> Header
    @ViewBuilder let expandedContent: () -> ExpandedContent

    @State private var isHovered = false

    var body: some View {
        VStack(spacing: 0) {
            header()

            if isExpanded {
                expandedContent()
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.98, anchor: .top)),
                            removal: .opacity.combined(with: .scale(scale: 0.98, anchor: .top))
                        )
                    )
            }
        }
        .contentShape(Rectangle())
        .padding(.horizontal, DesignTokens.Spacing.sm)
        .padding(.vertical, DesignTokens.Spacing.xs)
        .glassRowBackground(isHovered: isHovered)
        .onHover { hovering in
            withAnimation(DesignTokens.Animation.hover) {
                isHovered = hovering
            }
        }
    }
}
