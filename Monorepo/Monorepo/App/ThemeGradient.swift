//
//  ThemeGradient.swift
//  Monorepo
//
//  Created by codeAlligator on 11/02/26.
//

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
