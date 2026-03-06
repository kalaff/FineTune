// FineTune/Views/Components/EQPresetPicker.swift
import SwiftUI

/// A picker for selecting EQ presets using the standardized Liquid Glass dropdown
struct EQPresetPicker: View {
    let selectedPreset: EQPreset?
    let onPresetSelected: (EQPreset) -> Void

    var body: some View {
        DropdownMenu(
            items: EQPreset.allCases,
            selectedItem: Binding(
                get: { selectedPreset },
                set: { if let p = $0 { onPresetSelected(p) } }
            ),
            titleProvider: { $0.rawValue },
            iconProvider: { _ in "waveform" },
            placeholder: "Manual"
        )
        .frame(width: 130)
    }
}
