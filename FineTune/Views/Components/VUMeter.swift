// FineTune/Views/Components/VUMeter.swift
import SwiftUI

/// A vertical VU meter visualization for audio levels with Liquid Glass styling
struct VUMeter: View {
    let level: Float
    var isMuted: Bool = false

    @State private var peakLevel: Float = 0
    @State private var peakHoldTimer: Timer?

    private let barCount = DesignTokens.Dimensions.vuMeterBarCount

    var body: some View {
        HStack(spacing: DesignTokens.Dimensions.vuMeterBarSpacing) {
            ForEach(0..<barCount, id: \.self) { index in
                VUMeterBar(
                    index: index,
                    level: level,
                    peakLevel: peakLevel,
                    barCount: barCount,
                    isMuted: isMuted
                )
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .background {
            // Subtle glass container for the meter
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .strokeBorder(.white.opacity(0.05), lineWidth: 0.5)
                )
        }
        .frame(width: DesignTokens.Dimensions.vuMeterWidth)
        .onChange(of: level) { _, newLevel in
            if newLevel > peakLevel {
                peakLevel = newLevel
                startPeakDecayTimer()
            } else if peakLevel > newLevel && peakHoldTimer == nil {
                startPeakDecayTimer()
            }
        }
        .onDisappear {
            peakHoldTimer?.invalidate()
            peakHoldTimer = nil
        }
    }

    private func startPeakDecayTimer() {
        peakHoldTimer?.invalidate()
        peakHoldTimer = Timer.scheduledTimer(withTimeInterval: DesignTokens.Timing.vuMeterPeakHold, repeats: false) { _ in
            startGradualDecay()
        }
    }

    private func startGradualDecay() {
        peakHoldTimer?.invalidate()
        peakHoldTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { timer in
            let decayRate: Float = 0.012
            if peakLevel > level {
                withAnimation(DesignTokens.Animation.vuMeterLevel) {
                    peakLevel = max(level, peakLevel - decayRate)
                }
            } else {
                timer.invalidate()
                peakHoldTimer = nil
            }
        }
    }
}

/// Individual bar in the VU meter with Liquid Glass glow
private struct VUMeterBar: View {
    let index: Int
    let level: Float
    let peakLevel: Float
    let barCount: Int
    var isMuted: Bool = false

    private static let dbThresholds: [Float] = [-40, -30, -20, -14, -10, -6, -3, 0]

    private var threshold: Float {
        let db = Self.dbThresholds[min(index, Self.dbThresholds.count - 1)]
        return powf(10, db / 20)
    }

    private var isLit: Bool { level >= threshold }

    private var isPeakIndicator: Bool {
        var peakBarIndex = 0
        for i in 0..<Self.dbThresholds.count {
            let thresh = powf(10, Self.dbThresholds[i] / 20)
            if peakLevel >= thresh { peakBarIndex = i }
        }
        return index == peakBarIndex && peakLevel > level
    }

    private var barColor: Color {
        if isMuted { return DesignTokens.Colors.vuMuted }
        if index < 4 { return DesignTokens.Colors.vuGreen }
        else if index < 6 { return DesignTokens.Colors.vuYellow }
        else if index < 7 { return DesignTokens.Colors.vuOrange }
        else { return DesignTokens.Colors.vuRed }
    }

    var body: some View {
        let isActive = isLit || isPeakIndicator
        
        RoundedRectangle(cornerRadius: 1.5, style: .continuous)
            .fill(isActive ? barColor : Color.white.opacity(0.1))
            .frame(
                width: (DesignTokens.Dimensions.vuMeterWidth - 8 - CGFloat(barCount - 1) * DesignTokens.Dimensions.vuMeterBarSpacing) / CGFloat(barCount),
                height: DesignTokens.Dimensions.vuMeterBarHeight
            )
            // Light-within-glass glow effect
            .shadow(color: isActive ? barColor.opacity(0.6) : .clear, radius: 2)
            .animation(DesignTokens.Animation.vuMeterLevel, value: isActive)
    }
}

// MARK: - Previews

#Preview("VU Meter - Horizontal") {
    ComponentPreviewContainer {
        VStack(spacing: DesignTokens.Spacing.md) {
            HStack {
                Text("0%")
                    .font(.caption)
                VUMeter(level: 0)
            }

            HStack {
                Text("25%")
                    .font(.caption)
                VUMeter(level: 0.25)
            }

            HStack {
                Text("50%")
                    .font(.caption)
                VUMeter(level: 0.5)
            }

            HStack {
                Text("75%")
                    .font(.caption)
                VUMeter(level: 0.75)
            }

            HStack {
                Text("100%")
                    .font(.caption)
                VUMeter(level: 1.0)
            }
        }
    }
}

#Preview("VU Meter - Animated") {
    struct AnimatedPreview: View {
        @State private var level: Float = 0

        var body: some View {
            ComponentPreviewContainer {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    VUMeter(level: level)

                    Slider(value: Binding(
                        get: { Double(level) },
                        set: { level = Float($0) }
                    ))
                }
            }
        }
    }
    return AnimatedPreview()
}
