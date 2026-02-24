//
//  ThemeGradient.swift
//  Monorepo
//
/// Created by `C S Prasad` on `11/02/26`
///
///`iOS • SwiftUI • Creative Coding`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios``
/// `X`                   : ``@csprasad_ios``
/// `Github`        : ``@csprasad``
///

import SwiftUI

enum ThemeGradient {
    static let accentVertical = LinearGradient(
        colors: [.yellow, .orange, .red],
        startPoint: .top,
        endPoint: .bottom
    )

    static let accentHorizontal = LinearGradient(
        colors: [.yellow, .orange, .red],
        startPoint: .leading,
        endPoint: .trailing
    )
}
