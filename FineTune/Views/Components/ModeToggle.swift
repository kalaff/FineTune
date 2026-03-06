// FineTune/Views/Components/ModeToggle.swift
import SwiftUI

/// A segmented control for switching between single and multi device modes with Liquid Glass styling
struct ModeToggle: View {
    @Binding var mode: DeviceSelectionMode
    @State private var hoveredOption: DeviceSelectionMode?

    private let options: [(mode: DeviceSelectionMode, label: String)] = [
        (.single, "Single"),
        (.multi, "Multi")
    ]

    var body: some View {
        HStack(spacing: 2) {
            ForEach(options, id: \.mode) { option in
                optionButton(option.mode, label: option.label)
            }
        }
        .padding(2)
        .background {
            RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius, style: .continuous)
                .fill(Color.white.opacity(0.05))
        }
        .overlay {
            RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius, style: .continuous)
                .strokeBorder(Color.white.opacity(0.15), lineWidth: 0.5)
        }
    }

    @ViewBuilder
    private func optionButton(_ optionMode: DeviceSelectionMode, label: String) -> some View {
        let isSelected = mode == optionMode
        let isHovered = hoveredOption == optionMode

        Button {
            withAnimation(DesignTokens.Animation.quick) {
                mode = optionMode
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 10))
                    .foregroundStyle(isSelected ? DesignTokens.Colors.accentPrimary : .secondary)

                Text(label)
                    .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 24)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius - 2, style: .continuous)
                        .fill(Color.white.opacity(0.15))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                } else if isHovered {
                    RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius - 2, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(DesignTokens.Animation.hover) {
                hoveredOption = hovering ? optionMode : nil
            }
        }
    }
}
