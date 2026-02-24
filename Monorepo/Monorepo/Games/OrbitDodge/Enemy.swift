//
//  Enemy.swift
//  Monorepo
//
/// Created by `C S Prasad` on `06/02/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

/// Polar-coordinate enemy moving toward the orbit center.
struct Enemy: Identifiable {
    let id = UUID()
    var angle: CGFloat
    var distance: CGFloat
}
