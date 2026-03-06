// FineTune/Views/Components/LiquidGlassSlider.swift
import SwiftUI

/// A slider using native SwiftUI Slider for Liquid Glass effect on macOS 26+
/// Styled to match the minimal track appearance of device sliders
struct LiquidGlassSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let showUnityMarker: Bool
    let onEditingChanged: ((Bool) -> Void)?

    @State private var isEditing = false
    @State private var isHovered = false

    /// Show thumb only when hovering or dragging
    private var showThumb: Bool {
        isHovered || isEditing
    }

    init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        showUnityMarker: Bool = false,
        onEditingChanged: ((Bool) -> Void)? = nil
    ) {
        self._value = value
        self.range = range
        self.showUnityMarker = showUnityMarker
        self.onEditingChanged = onEditingChanged
    }

    private let trackHeight: CGFloat = 4

    private var normalizedValue: Double {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }

    // Parallax offset for hover fluidity
    private var parallaxOffset: CGFloat {
        isHovered ? 1.5 : 0
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Custom track overlay (always visible, hides native track)
                ZStack(alignment: .leading) {
                    // Track background - Floating Capsule with Refraction & Specularity
                    ZStack {
                        RoundedRectangle(cornerRadius: trackHeight / 2, style: .continuous)
                            .fill(.ultraThinMaterial) // Refraction
                        RoundedRectangle(cornerRadius: trackHeight / 2, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.15),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1) // Outer shadow
                    .overlay(
                        RoundedRectangle(cornerRadius: trackHeight / 2, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.4), lineWidth: 0.5) // Inner double-layer border
                    )
                    .frame(height: trackHeight)
                    .offset(y: parallaxOffset)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isHovered)

                    // Filled track - Highlighting the value
                    RoundedRectangle(cornerRadius: trackHeight / 2, style: .continuous)
                        .fill(DesignTokens.Colors.accentPrimary)
                        .shadow(color: DesignTokens.Colors.accentPrimary.opacity(0.3), radius: 3, x: 0, y: 1) // Specular glow
                        .frame(width: max(trackHeight, geo.size.width * normalizedValue), height: trackHeight)
                        .offset(y: parallaxOffset)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isHovered)
                }
                .frame(maxHeight: .infinity)
                .allowsHitTesting(false)

                // Unity marker at 50% (horizontally centered, vertically centered via frame)
                if showUnityMarker {
                    HStack {
                        Spacer()
                        Rectangle()
                            .fill(DesignTokens.Colors.unityMarker)
                            .frame(width: 1.5, height: 8)
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                    .allowsHitTesting(false)
                }

                // Native SwiftUI Slider - gets Liquid Glass thumb on macOS 26+
                // Thumb only visible on hover/drag
                Slider(value: $value, in: range) { editing in
                    isEditing = editing
                    onEditingChanged?(editing)
                }
                .controlSize(.mini)
                .tint(.clear)  // Hide native track, we draw our own
                .opacity(showThumb ? 1 : 0.01)  // Nearly invisible when not hovered, but still interactive
            }
        }
        .frame(height: DesignTokens.Dimensions.sliderThumbHeight)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Preview

#Preview("Liquid Glass Slider") {
    struct PreviewWrapper: View {
        @State private var value: Double = 0.5

        var body: some View {
            VStack(spacing: 30) {
                LiquidGlassSlider(value: $value, showUnityMarker: true)
                    .frame(width: 200)

                Text("\(Int(value * 200))%")
                    .foregroundStyle(.secondary)
            }
            .padding(40)
            .background(Color.black)
        }
    }
    return PreviewWrapper()
}
