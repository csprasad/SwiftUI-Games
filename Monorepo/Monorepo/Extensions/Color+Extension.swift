//
//
//  Color+Extension.swift
//  Monorepo
//
/// Created by `C S Prasad` on `25/02/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Color Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            .sRGB,
            red: Double((int >> 16) & 0xFF) / 255,
            green: Double((int >> 8) & 0xFF) / 255,
            blue: Double(int & 0xFF) / 255,
            opacity: 1
        )
    }
}

// MARK: - Color Blend
extension Color {
    /// Creates a color by linearly interpolating between the receiver and another color.
    /// - Parameters:
    ///   - other: The color to blend with the receiver.
    ///   - amount: Interpolation factor between 0 and 1 where 0 yields the receiver and 1 yields `other`.
    /// - Returns: A color whose red, green, blue, and opacity channels are the linear interpolation of the two colors according to `amount`.
    func blend(with other: Color, amount: Double = 0.5) -> Color {
        let uiColor1 = UIColor(self)
        let uiColor2 = UIColor(other)

        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0

        uiColor1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        uiColor2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        return Color(
            red: Double(red1) * (1 - amount) + Double(red2) * amount,
            green: Double(green1) * (1 - amount) + Double(green2) * amount,
            blue: Double(blue1) * (1 - amount) + Double(blue2) * amount,
            opacity: Double(alpha1) * (1 - amount) + Double(alpha2) * amount
        )
    }
}
