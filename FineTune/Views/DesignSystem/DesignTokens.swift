// FineTune/Views/DesignSystem/DesignTokens.swift
import SwiftUI

/// Design System tokens - Perfectly aligned with macOS 15+ Sequoia/Tahoe Control Center
enum DesignTokens {

    // MARK: - Colors

    enum Colors {
        // MARK: Text
        static let textPrimary: Color = .primary
        static let textSecondary: Color = .secondary
        static let textTertiary = Color(nsColor: .tertiaryLabelColor)
        static let textQuaternary = Color(nsColor: .quaternaryLabelColor)

        // MARK: Interactive (System Control Style)
        static let interactiveDefault: Color = .white.opacity(0.7)
        static let interactiveHover: Color = .white
        static let interactiveActive: Color = .white
        static let accentPrimary: Color = .accentColor
        static let defaultDevice: Color = .accentColor

        // MARK: Slider (The 'Control Center' White Look)
        static let sliderTrack: Color = .black.opacity(0.3)
        static let sliderFill: Color = .white
        static let unityMarker: Color = .white.opacity(0.3)

        // MARK: Borders
        static let glassBorder = Color.white.opacity(0.15)
        static let glassBorderHover = Color.white.opacity(0.3)

        // MARK: Glass Effects
        static let popupOverlay: Color = .clear
        static let recessedBackground: Color = .black.opacity(0.1)

        // MARK: VU Meter
        static let vuGreen = Color(red: 0.35, green: 0.95, blue: 0.55)
        static let vuYellow = Color(red: 1.0, green: 0.90, blue: 0.35)
        static let vuOrange = Color(red: 1.0, green: 0.65, blue: 0.25)
        static let vuRed = Color(red: 1.0, green: 0.40, blue: 0.40)
        static let vuUnlit: Color = .white.opacity(0.08)
        static let vuMuted: Color = .white.opacity(0.2)
        static let mutedIndicator = Color(nsColor: .systemRed)

        // MARK: Menu & Picker
        static let pickerBackground: Color = .white.opacity(0.08)
        static let pickerHover: Color = .white.opacity(0.15)
        static let menuBackground: Color = .clear
        static let menuBorder: Color = .white.opacity(0.2)
        static let menuBorderHover: Color = .white.opacity(0.4)
        
        static let thumbBackground: Color = .white
        static let thumbDot: Color = .black.opacity(0.8)
    }

    // MARK: - Typography

    enum Typography {
        static let sectionHeader = Font.system(size: 11, weight: .bold)
        static let sectionHeaderTracking: CGFloat = 1.2
        static let rowName = Font.system(size: 13, weight: .medium)
        static let rowNameBold = Font.system(size: 13, weight: .bold)
        static let percentage = Font.system(size: 11, weight: .semibold, design: .monospaced)
        static let caption = Font.system(size: 10, weight: .regular)
        static let pickerText = Font.system(size: 11, weight: .medium)
        static let eqLabel = Font.system(size: 9, weight: .bold, design: .monospaced)
    }

    // MARK: - Spacing

    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
    }

    // MARK: - Dimensions

    enum Dimensions {
        static let popupWidth: CGFloat = 580
        static let contentPadding: CGFloat = 16
        static var contentWidth: CGFloat { popupWidth - (contentPadding * 2) }
        
        static let cornerRadius: CGFloat = 24
        static let rowRadius: CGFloat = 18
        static let buttonRadius: CGFloat = 10
        
        static let iconSize: CGFloat = 20
        static let iconSizeSmall: CGFloat = 14
        static let rowContentHeight: CGFloat = 40
        static let sliderWidth: CGFloat = 160
        static let vuMeterWidth: CGFloat = 28
        static var controlsWidth: CGFloat { contentWidth - iconSize - 12 - 100 }
        static let percentageWidth: CGFloat = 40
        static let minTouchTarget: CGFloat = 16
        static let maxScrollHeight: CGFloat = 400
        
        static let sliderTrackHeight: CGFloat = 4
        static let sliderThumbSize: CGFloat = 0
        
        static let vuMeterBarHeight: CGFloat = 10
        static let vuMeterBarSpacing: CGFloat = 2
        static let vuMeterBarCount: Int = 8
        static let settingsIconWidth: CGFloat = 24
        static let settingsSliderWidth: CGFloat = 200
        static let settingsPercentageWidth: CGFloat = 44
        static let settingsPickerWidth: CGFloat = 120
    }

    // MARK: - Animation
    enum Animation {
        static let quick = SwiftUI.Animation.spring(response: 0.25, dampingFraction: 0.75)
        static let hover = SwiftUI.Animation.spring(response: 0.35, dampingFraction: 0.7)
        static let vuMeterLevel = SwiftUI.Animation.linear(duration: 0.05)
    }
    
    enum Timing {
        static let vuMeterUpdateInterval: TimeInterval = 1.0 / 30.0
        static let vuMeterPeakHold: TimeInterval = 0.5
    }
}
