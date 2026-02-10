//
//  Enemy.swift
//  Monorepo
//
//  Created by codeAlligator on 06/02/26.
//

import SwiftUI

/// Polar-coordinate enemy moving toward the orbit center.
struct Enemy: Identifiable {
    let id = UUID()
    var angle: CGFloat
    var distance: CGFloat
}
