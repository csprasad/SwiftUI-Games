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
        self.init(.sRGB, red: Double((int >> 16) & 0xFF) / 255, green: Double((int >> 8) & 0xFF) / 255, blue: Double(int & 0xFF) / 255, opacity: 1)
    }
}

// MARK: - Color Blend
extension Color {
    func blend(with other: Color, amount: Double = 0.5) -> Color {
        let uiColor1 = UIColor(self)
        let uiColor2 = UIColor(other)
        
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        uiColor1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        uiColor2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return Color(
            red: Double(r1) * (1 - amount) + Double(r2) * amount,
            green: Double(g1) * (1 - amount) + Double(g2) * amount,
            blue: Double(b1) * (1 - amount) + Double(b2) * amount,
            opacity: Double(a1) * (1 - amount) + Double(a2) * amount
        )
    }
}
