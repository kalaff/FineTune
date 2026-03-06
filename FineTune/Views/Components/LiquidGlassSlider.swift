// FineTune/Views/Components/LiquidGlassSlider.swift
import SwiftUI

/// A minimalist white-fill slider that matches the macOS Control Center aesthetic.
/// Features a horizontal oval knob: visible on hover, transparent during dragging.
struct LiquidGlassSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let showUnityMarker: Bool
    let onEditingChanged: ((Bool) -> Void)?

    @State private var isEditing = false
    @State private var isHovered = false

    // Dimensions for the 'Official' look
    private let trackHeight: CGFloat = 4
    private let knobWidth: CGFloat = 16
    private let knobHeight: CGFloat = 10

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

    private var normalizedValue: Double {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // 1. Recessed Track (Dark line)
                Capsule()
                    .fill(Color.black.opacity(0.35))
                    .frame(height: trackHeight)
                
                // 2. Active Fill (Solid White)
                Capsule()
                    .fill(Color.white)
                    .frame(width: max(trackHeight, geo.size.width * normalizedValue), height: trackHeight)
                    .shadow(color: .white.opacity(0.2), radius: 4, x: 0, y: 0)
                    .allowsHitTesting(false)

                // 3. THE DYNAMIC OVAL KNOB (Horizontal Capsule)
                Capsule()
                    .fill(Color.white)
                    .frame(width: knobWidth, height: knobHeight)
                    // Precise alignment at the end of the fill
                    .offset(x: (geo.size.width - knobWidth) * normalizedValue)
                    // Logic: 1.0 when hovering (not dragging), 0.0 when dragging
                    .opacity(isHovered ? (isEditing ? 0 : 1) : 0)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                    .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isHovered)
                    .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isEditing)
                    .allowsHitTesting(false)

                // 4. THE INTERACTIVE ENGINE (Invisible)
                Slider(value: $value, in: range) { editing in
                    withAnimation(.spring(response: 0.2)) {
                        isEditing = editing
                    }
                    onEditingChanged?(editing)
                }
                .accentColor(.clear)
                .opacity(0.01)
                .contentShape(Rectangle())
            }
            .frame(height: 24)
            .offset(y: (geo.size.height - 24) / 2)
        }
        .frame(height: 32)
        .onHover { hovering in
            withAnimation(.spring(response: 0.25)) {
                isHovered = hovering
            }
        }
    }
}
