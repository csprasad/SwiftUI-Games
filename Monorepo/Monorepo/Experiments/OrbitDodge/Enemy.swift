//
//  Enemy.swift
//  Monorepo
//
//  Created by codeAlligator on 06/02/26.
//

import SwiftUI

struct Enemy: Identifiable {
    let id = UUID()
    var angle: CGFloat
    var distance: CGFloat
}
