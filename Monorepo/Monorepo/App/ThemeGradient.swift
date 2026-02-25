//
//  ThemeGradient.swift
//  Monorepo
//
/// Created by `C S Prasad` on `11/02/26`
///
///`iOS • SwiftUI • Creative Coding`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

enum ThemeGradient {
    
    // MARK: - Verticle orange accent colors
    static let accentVertical = LinearGradient(
        colors: [.yellow, .orange, .red],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Horizontal orange accent colors
    static let accentHorizontal = LinearGradient(
        colors: [.yellow, .orange, .red],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // MARK: - Pipe dark gradient colors
    static func pixelPipeGradient(for scheme: ColorScheme) -> LinearGradient {
        let isLight = scheme == .light
        
        let darkColors = LinearGradient(
            stops: [
                .init(color: Color(hex: "391D2A"), location: 0.0),    // Darkest Left Edge
                .init(color: Color(hex: "80BC57"), location: 0.05),   // Highlight/Transition
                .init(color: Color(hex: "80BC57"), location: 0.1),    // Main Light Green
                .init(color: Color(hex: "3D9D53"), location: 0.2),    // Mid Green
                .init(color: Color(hex: "3E9E53"), location: 0.3),
                .init(color: Color(hex: "389948"), location: 0.4),
                .init(color: Color(hex: "2F8E35"), location: 0.5),    // Center Shadow Start
                .init(color: Color(hex: "319037"), location: 0.6),
                .init(color: Color(hex: "26812E"), location: 0.7),
                .init(color: Color(hex: "237B2C"), location: 0.8),    // Deep Shadow
                .init(color: Color(hex: "2A6E28"), location: 0.85),
                .init(color: Color(hex: "336523"), location: 0.9),
                .init(color: Color(hex: "319036"), location: 0.95),
                .init(color: Color(hex: "391D2A"), location: 1.0)     // Darkest Right Edge
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        let liteColors = LinearGradient(
            stops: [
                .init(color: Color(hex: "5A3D4A"), location: 0.0),    // Lighter Edge
                .init(color: Color(hex: "A8E081"), location: 0.05),   // Bright Highlight
                .init(color: Color(hex: "A8E081"), location: 0.1),
                .init(color: Color(hex: "64C27A"), location: 0.2),    // Light Mid-Green
                .init(color: Color(hex: "65C37A"), location: 0.3),
                .init(color: Color(hex: "5FBF6F"), location: 0.4),
                .init(color: Color(hex: "55B45B"), location: 0.5),
                .init(color: Color(hex: "57B65D"), location: 0.6),
                .init(color: Color(hex: "4CA754"), location: 0.7),
                .init(color: Color(hex: "49A152"), location: 0.8),    // Soft Shadow
                .init(color: Color(hex: "50944E"), location: 0.85),
                .init(color: Color(hex: "598B49"), location: 0.9),
                .init(color: Color(hex: "57B65C"), location: 0.95),
                .init(color: Color(hex: "5A3D4A"), location: 1.0)     // Lighter Edge
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        return isLight ? liteColors : darkColors
    }
}
