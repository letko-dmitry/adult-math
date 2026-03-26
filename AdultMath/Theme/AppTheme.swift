import SwiftUI

enum AppTheme {
    // MARK: - Colors

    static let accentGreen = Color(red: 0.35, green: 0.75, blue: 0.45)
    static let accentOrange = Color(red: 0.95, green: 0.55, blue: 0.25)

    static let correctText = Color(red: 0.08, green: 0.36, blue: 0.20)
    static let incorrectText = Color(red: 0.55, green: 0.28, blue: 0.07)

    static let streakFlame = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let screenBackground = Color(uiColor: .systemBackground)

    static let receiptBackground = Color(red: 0.99, green: 0.97, blue: 0.93)
    static let nutritionBorder = Color.black

    static let revealBackground = Color(red: 1.0, green: 0.96, blue: 0.87)
    static let revealBorder = Color(red: 0.95, green: 0.87, blue: 0.76)
    static let revealText = Color(red: 0.54, green: 0.35, blue: 0.11)

    // MARK: - Typography

    static let displayTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let hookTitle = Font.system(size: 32, weight: .bold, design: .rounded)
    static let heroTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let sectionTitle = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let subtitleLarge = Font.system(size: 20, weight: .regular, design: .rounded)
    static let questionTitle = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let subtitle = Font.system(size: 17, weight: .regular, design: .rounded)
    static let bodyText = Font.system(size: 16, weight: .regular, design: .rounded)
    static let bodyMedium = Font.system(size: 16, weight: .medium, design: .rounded)
    static let bodySemibold = Font.system(size: 15, weight: .semibold, design: .rounded)
    static let caption = Font.system(size: 14, weight: .regular, design: .rounded)
    static let captionMedium = Font.system(size: 14, weight: .medium, design: .rounded)
    static let smallCaption = Font.system(size: 13, weight: .medium, design: .rounded)
    static let smallSemibold = Font.system(size: 13, weight: .semibold, design: .rounded)
    static let smallBold = Font.system(size: 13, weight: .bold, design: .rounded)
    static let chip = Font.system(size: 12, weight: .regular, design: .rounded)
    static let chipSemibold = Font.system(size: 12, weight: .semibold, design: .rounded)
    static let tiny = Font.system(size: 11, weight: .medium, design: .rounded)
    static let tinySemibold = Font.system(size: 11, weight: .semibold, design: .rounded)
    static let receiptFont = Font.system(size: 14, weight: .regular, design: .monospaced)
    static let receiptBold = Font.system(size: 14, weight: .bold, design: .monospaced)

    // MARK: - Spacing

    static let spacingTight: CGFloat = 6
    static let paddingSmall: CGFloat = 8
    static let spacingSection: CGFloat = 12
    static let paddingMedium: CGFloat = 16
    static let spacingContent: CGFloat = 20
    static let paddingLarge: CGFloat = 24
    static let paddingXLarge: CGFloat = 32
    static let bottomScreenCTAInset: CGFloat = 16

    static let cornerRadius: CGFloat = 16
    static let cardCornerRadius: CGFloat = 20
    static let buttonCornerRadius: CGFloat = 12

}
