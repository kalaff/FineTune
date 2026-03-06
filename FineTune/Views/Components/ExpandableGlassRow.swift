// FineTune/Views/Components/ExpandableGlassRow.swift
import SwiftUI

/// A reusable expandable row with Liquid Glass styling
/// The glass container grows/shrinks smoothly during expansion using SwiftUI's natural height calculation
struct ExpandableGlassRow<Header: View, ExpandedContent: View>: View {
    let isExpanded: Bool
    @ViewBuilder let header: () -> Header
    @ViewBuilder let expandedContent: () -> ExpandedContent

    @State private var isHovered = false

    var body: some View {
        VStack(spacing: 0) {
            // Header content - always visible
            header()

            // Expandable content - conditional rendering lets SwiftUI calculate natural height
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
        .padding(.horizontal, DesignTokens.Spacing.sm)
        .padding(.vertical, DesignTokens.Spacing.xs)
        // Background container with Refraction & Specularity
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: DesignTokens.Dimensions.rowRadius, style: .continuous)
                    .fill(.ultraThinMaterial) // Refraction
                RoundedRectangle(cornerRadius: DesignTokens.Dimensions.rowRadius, style: .continuous)
                    .fill(
                        LinearGradient( // Specularity
                            colors: [
                                Color.white.opacity(0.12),
                                Color.white.opacity(0.04)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .shadow(color: .black.opacity(isHovered ? 0.2 : 0.1), radius: isHovered ? 4 : 2, x: 0, y: isHovered ? 2 : 1) // Outer shadow changing on hover
            .offset(y: isHovered ? 1.0 : 0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isHovered)
        }
        // Double-Layer Border (inner white border)
        .overlay {
            RoundedRectangle(cornerRadius: DesignTokens.Dimensions.rowRadius, style: .continuous)
                .strokeBorder(Color.white.opacity(isHovered ? 0.3 : 0.15), lineWidth: 0.5)
                .allowsHitTesting(false)
                .offset(y: isHovered ? 1.0 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isHovered)
        }
        // Hover highlight overlay
        .overlay {
            ZStack {
                if isHovered {
                    RoundedRectangle(cornerRadius: DesignTokens.Dimensions.rowRadius, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .offset(y: 1.0)
                        .transition(.opacity)
                }
            }
        }
        .onHover { hovering in
            isHovered = hovering
        }
        .animation(DesignTokens.Animation.hover, value: isHovered)
        // NOTE: Do NOT add .animation(_, value: isExpanded) here!
        // Animation is handled by the caller via withAnimation in onEQToggle.
        // Adding animation here causes layout loops with conditional content rendering.
    }
}

// MARK: - Previews

#Preview("Expandable Glass Row - Collapsed") {
    PreviewContainer {
        ExpandableGlassRow(isExpanded: false) {
            HStack {
                Image(systemName: "music.note")
                Text("Spotify")
                Spacer()
                Text("75%")
                    .foregroundStyle(.secondary)
            }
            .frame(height: DesignTokens.Dimensions.rowContentHeight)
        } expandedContent: {
            VStack {
                Text("Expanded Content")
                    .padding()
            }
            .frame(height: 100)
            .background(DesignTokens.Colors.recessedBackground)
        }
    }
}

#Preview("Expandable Glass Row - Expanded") {
    PreviewContainer {
        ExpandableGlassRow(isExpanded: true) {
            HStack {
                Image(systemName: "music.note")
                Text("Spotify")
                Spacer()
                Text("75%")
                    .foregroundStyle(.secondary)
            }
            .frame(height: DesignTokens.Dimensions.rowContentHeight)
        } expandedContent: {
            VStack(spacing: 8) {
                Text("EQ Panel Content")
                HStack(spacing: 16) {
                    ForEach(0..<5, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.secondary)
                            .frame(width: 4, height: 60)
                    }
                }
            }
            .padding(.top, DesignTokens.Spacing.sm)
            .padding(.bottom, DesignTokens.Spacing.xs)
        }
    }
}
