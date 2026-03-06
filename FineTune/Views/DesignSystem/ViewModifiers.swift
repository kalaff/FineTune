// FineTune/Views/DesignSystem/ViewModifiers.swift
import SwiftUI

// MARK: - Hoverable Row Modifier (Unified Glass)

struct HoverableRowModifier: ViewModifier {
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
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

// MARK: - Section Header Style Modifier

struct SectionHeaderStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(DesignTokens.Typography.sectionHeader)
            .foregroundStyle(DesignTokens.Colors.textSecondary)
            .tracking(DesignTokens.Typography.sectionHeaderTracking)
            .textCase(.uppercase)
    }
}

// MARK: - Percentage Text Style Modifier

struct PercentageTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(DesignTokens.Typography.percentage)
            .foregroundStyle(DesignTokens.Colors.textSecondary)
            .frame(width: DesignTokens.Dimensions.percentageWidth, alignment: .trailing)
    }
}

// MARK: - Icon Button Style Modifier

struct IconButtonStyleModifier: ViewModifier {
    let isActive: Bool
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .foregroundStyle(foregroundColor)
            .symbolRenderingMode(.hierarchical)
            .frame(minWidth: DesignTokens.Dimensions.minTouchTarget,
                   minHeight: DesignTokens.Dimensions.minTouchTarget)
            .contentShape(Rectangle())
            .onHover { hovering in
                withAnimation(DesignTokens.Animation.hover) {
                    isHovered = hovering
                }
            }
    }

    private var foregroundColor: Color {
        if isActive {
            return DesignTokens.Colors.mutedIndicator
        } else if isHovered {
            return .primary
        } else {
            return .primary.opacity(0.7)
        }
    }
}

// MARK: - Glass Button Style Modifier (Unified)

struct GlassButtonStyleModifier: ViewModifier {
    @State private var isHovered = false
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(VisualEffectBackground(material: .selection, blendingMode: .withinWindow))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(isHovered ? 0.4 : 0.2), lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius, style: .continuous))
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .onHover { hovering in
                withAnimation(DesignTokens.Animation.hover) {
                    isHovered = hovering
                }
            }
    }
}

// MARK: - View Extensions

extension View {
    func hoverableRow() -> some View {
        modifier(HoverableRowModifier())
    }

    func sectionHeaderStyle() -> some View {
        modifier(SectionHeaderStyleModifier())
    }

    func percentageStyle() -> some View {
        modifier(PercentageTextModifier())
    }

    func iconButtonStyle(isActive: Bool = false) -> some View {
        modifier(IconButtonStyleModifier(isActive: isActive))
    }

    func glassButtonStyle() -> some View {
        modifier(GlassButtonStyleModifier())
    }
}
