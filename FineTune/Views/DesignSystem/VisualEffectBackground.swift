// FineTune/Views/DesignSystem/VisualEffectBackground.swift
import SwiftUI
import AppKit

/// Pure Liquid Glass background using system materials
struct VisualEffectBackground: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .popover
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// MARK: - View Extensions

extension View {
    /// Applies the 'Crystal Clear' popup container style
    func darkGlassBackground() -> some View {
        self
            .background(VisualEffectBackground(material: .popover, blendingMode: .behindWindow))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Dimensions.cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.15), radius: 30, x: 0, y: 15)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Dimensions.cornerRadius, style: .continuous))
    }

    /// Unified chunky capsule background for rows (Matches Control Center)
    func glassRowBackground(isHovered: Bool) -> some View {
        self
            .background(
                ZStack {
                    // Deep translucent material
                    VisualEffectBackground(material: .selection, blendingMode: .withinWindow)
                        .opacity(isHovered ? 0.95 : 0.75)
                    
                    // Subtle light-wash
                    Color.white.opacity(0.02)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Dimensions.rowRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(isHovered ? 0.3 : 0.15), lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Dimensions.rowRadius, style: .continuous))
            .padding(.horizontal, 4) // Breathing room from container edge
    }
}
