// FineTune/Views/Components/DropdownMenu.swift
import SwiftUI

/// A reusable dropdown menu component with Liquid Glass styling
struct DropdownMenu<Item: Identifiable & Equatable>: View {
    let items: [Item]
    @Binding var selectedItem: Item?
    let titleProvider: (Item) -> String
    let iconProvider: ((Item) -> String)?
    let placeholder: String

    @State private var isExpanded = false
    @State private var isButtonHovered = false

    private let popoverWidth: CGFloat = 180
    private let itemHeight: CGFloat = 26

    var body: some View {
        Button {
            withAnimation(.snappy(duration: 0.2)) {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                if let selected = selectedItem {
                    HStack(spacing: 6) {
                        if let iconProvider {
                            Image(systemName: iconProvider(selected))
                                .font(.system(size: 11))
                        }
                        Text(titleProvider(selected))
                            .font(.system(size: 11, weight: .semibold))
                    }
                } else {
                    Text(placeholder)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(isExpanded ? -180 : 0))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .frame(minWidth: 100)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background {
            RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius, style: .continuous)
                .fill(Color.white.opacity(0.08))
        }
        .overlay {
            RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius, style: .continuous)
                .strokeBorder(Color.white.opacity(isButtonHovered ? 0.4 : 0.2), lineWidth: 0.5)
        }
        .onHover { isButtonHovered = $0 }
        .background(
            PopoverHost(isPresented: $isExpanded) {
                dropdownContent
            }
        )
    }

    private var dropdownContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 2) {
                ForEach(items) { item in
                    Button {
                        selectedItem = item
                        withAnimation(.easeOut(duration: 0.15)) {
                            isExpanded = false
                        }
                    } label: {
                        HStack(spacing: 6) {
                            if selectedItem == item {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(DesignTokens.Colors.accentPrimary)
                                    .frame(width: 12)
                            } else {
                                Spacer().frame(width: 12)
                            }

                            if let iconProvider {
                                Image(systemName: iconProvider(item))
                                    .font(.system(size: 11))
                            }

                            Text(titleProvider(item))
                                .font(.system(size: 11))
                                .lineLimit(1)

                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        .frame(height: itemHeight)
                        .background {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(selectedItem == item ? Color.accentColor.opacity(0.15) : Color.clear)
                        }
                    }
                    .buttonStyle(DropdownItemButtonStyle())
                }
            }
            .padding(6)
        }
        .frame(width: popoverWidth)
        .background(
            VisualEffectBackground(material: .menu, blendingMode: .behindWindow)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Dimensions.rowRadius, style: .continuous))
        )
        .overlay {
            RoundedRectangle(cornerRadius: DesignTokens.Dimensions.rowRadius, style: .continuous)
                .strokeBorder(Color.white.opacity(0.3), lineWidth: 0.5)
        }
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
    }
}

private struct DropdownItemButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .overlay {
                if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.05))
                }
            }
    }
}
