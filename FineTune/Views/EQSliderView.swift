// FineTune/Views/EQSliderView.swift
import SwiftUI

/// A vertical slider for EQ bands with Liquid Glass styling
struct EQSliderView: View {
    let frequency: String
    @Binding var gain: Float
    let range: ClosedRange<Float> = -12...12

    @State private var localGain: Float = 0
    @State private var isDragging: Bool = false
    @State private var isHovered: Bool = false

    private let trackWidth: CGFloat = 6
    private let thumbSize: CGFloat = 16
    private let verticalPadding: CGFloat = 12

    private func formatGain(_ gain: Float) -> String {
        gain >= 0 ? String(format: "+%.0f", gain) : String(format: "%.0f", gain)
    }

    private var parallaxOffset: CGFloat {
        (isHovered || isDragging) ? 1.0 : 0
    }

    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geo in
                let travelHeight = geo.size.height - (verticalPadding * 2)
                let normalizedGain = CGFloat((localGain - range.lowerBound) / (range.upperBound - range.lowerBound))
                let thumbY = verticalPadding + travelHeight * (1 - normalizedGain)

                ZStack {
                    // 1. Background Track (Glass Tube)
                    ZStack {
                        RoundedRectangle(cornerRadius: trackWidth / 2, style: .continuous)
                            .fill(.ultraThinMaterial)
                        
                        RoundedRectangle(cornerRadius: trackWidth / 2, style: .continuous)
                            .strokeBorder(.white.opacity(0.15), lineWidth: 0.5)
                    }
                    .frame(width: trackWidth)
                    .offset(y: parallaxOffset)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)

                    // 2. Center (Unity) Marker
                    Rectangle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 14, height: 1.5)
                        .offset(y: parallaxOffset)

                    // 3. THE THUMB (Floating Glass Lens)
                    ZStack {
                        // Glass Lens
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Circle()
                                    .strokeBorder(.white.opacity(0.5), lineWidth: 0.5)
                            )
                        
                        // Center Dot (Active indicator)
                        Circle()
                            .fill(DesignTokens.Colors.accentPrimary)
                            .frame(width: 4, height: 4)
                            .shadow(color: DesignTokens.Colors.accentPrimary.opacity(0.6), radius: 3)
                    }
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    .position(x: geo.size.width / 2, y: thumbY + parallaxOffset)

                    // 4. Interaction Area
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    isDragging = true
                                    let normalizedY = (value.location.y - verticalPadding) / travelHeight
                                    let normalized = 1 - normalizedY
                                    let clamped = min(max(normalized, 0), 1)
                                    let newGain = Float(clamped) * (range.upperBound - range.lowerBound) + range.lowerBound
                                    localGain = newGain
                                    gain = newGain
                                }
                                .onEnded { _ in
                                    isDragging = false
                                }
                        )
                }
            }
            .frame(width: 32) // Touch width
            .onHover { hovering in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isHovered = hovering
                }
            }

            // Labels
            VStack(spacing: 0) {
                Text(formatGain(localGain))
                    .font(.system(size: 9, weight: .bold).monospacedDigit())
                    .foregroundStyle(isDragging ? DesignTokens.Colors.accentPrimary : .secondary)
                
                Text(frequency)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.primary)
            }
            .offset(y: parallaxOffset)
        }
        .onAppear { localGain = gain }
        .onChange(of: gain) { _, newValue in localGain = newValue }
    }
}

#Preview {
    HStack(spacing: 8) {
        EQSliderView(frequency: "32", gain: .constant(6))
        EQSliderView(frequency: "1k", gain: .constant(0))
        EQSliderView(frequency: "16k", gain: .constant(-6))
    }
    .frame(width: 120, height: 120)
    .padding()
    .darkGlassBackground()
    .environment(\.colorScheme, .dark)
}
