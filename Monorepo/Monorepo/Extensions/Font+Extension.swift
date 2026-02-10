//
//  Font+Extension.swift
//  Monorepo
//
//  Created by codeAlligator on 31/01/26.
//

import SwiftUI

extension Font {
    // Honk with different sizes
    static func honk(size: CGFloat = 17) -> Font {
        .custom("Honk-Regular", size: size)
    }
    
    // Bungee with different sizes
    static func bungee(size: CGFloat = 17) -> Font {
        .custom("Bungee-Regular", size: size)
    }
    
    // Bungee Spice with different sizes
    static func bungeeSpice(size: CGFloat = 17) -> Font {
        .custom("BungeeSpice-Regular", size: size)
    }
    
    // Retro with different sizes
    static func retroGaming(size: CGFloat = 17) -> Font {
        .custom("RetroGaming", size: size)
    }
    
    // Retro-lite with different sizes
    static func rainyHearts(size: CGFloat = 17) -> Font {
        .custom("rainyhearts", size: size)
    }
    
    // Match system font sizes of Honk
    static var honkTitle: Font { .honk(size: 28) }
    static var honkTitle2: Font { .honk(size: 22) }
    static var honkTitle3: Font { .honk(size: 20) }
    static var honkBody: Font { .honk(size: 12) }
    static var honkLargeTitle: Font { .honk(size: 34) }
    static var honkHeadline: Font { .honk(size: 17) }
    static var honkCaption: Font { .honk(size: 10) }
    
    // Match system font sizes of Bungee
    static var bungeeTitle: Font { .bungee(size: 28) }
    static var bungeeTitle2: Font { .bungee(size: 22) }
    static var bungeeTitle3: Font { .bungee(size: 20) }
    static var bungeeBody: Font { .bungee(size: 12) }
    static var bungeeLargeTitle: Font { .bungee(size: 34) }
    static var bungeeHeadline: Font { .bungee(size: 17) }
    static var bungeeCaption: Font { .bungee(size: 10) }
    
    // Match system font sizes of Bungee Spice
    static var bungeeSpiceTitle: Font { .bungeeSpice(size: 28) }
    static var bungeeSpiceTitle2: Font { .bungeeSpice(size: 22) }
    static var bungeeSpiceTitle3: Font { .bungeeSpice(size: 20) }
    static var bungeeSpiceBody: Font { .bungeeSpice(size: 12) }
    static var bungeeSpiceLargeTitle: Font { .bungeeSpice(size: 34) }
    static var bungeeSpiceHeadline: Font { .bungeeSpice(size: 17) }
    static var bungeeSpiceCaption: Font { .bungeeSpice(size: 10) }
    
    // Match system font sizes of Retro
    static var retroGameTitle: Font { .retroGaming(size: 28) }
    static var retroGameTitle2: Font { .retroGaming(size: 22) }
    static var retroGameTitle3: Font { .retroGaming(size: 20) }
    static var retroGameBody: Font { .retroGaming(size: 12) }
    static var retroGameLargeTitle: Font { .retroGaming(size: 34) }
    static var retroGameHeadline: Font { .retroGaming(size: 17) }
    static var retroGameCaption: Font { .retroGaming(size: 10) }
    
    // Match system font sizes of Retro-lite
    static var rainyHeartLiteTitle: Font { .rainyHearts(size: 28) }
    static var rainyHeartTitle2: Font { .rainyHearts(size: 22) }
    static var rainyHeartTitle3: Font { .rainyHearts(size: 20) }
    static var rainyHeartBody: Font { .rainyHearts(size: 12) }
    static var rainyHeartLargeTitle: Font { .rainyHearts(size: 34) }
    static var rainyHeartHeadline: Font { .rainyHearts(size: 17) }
    static var rainyHeartCaption: Font { .rainyHearts(size: 10) }

}
