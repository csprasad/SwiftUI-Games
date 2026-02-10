//
//  GameRoute.swift
//  Monorepo
//
//  Created by codeAlligator on 30/01/26.
//

import SwiftUI

struct GameInfo {
    var title: String
    var note: String
    var icon: String
    var isAvailable: Bool = true
}

enum GameRoute: Hashable, Identifiable {
    case commitSnake
    case ComingSoon
    case DinoRun
    case Flappy
    case Orbit_Dodge
    
    var id: Self { self }
    
    var info: GameInfo {
        switch self {
        case .commitSnake:
            GameInfo(title: "Commit Snake",
                    note: "Grow your green streak, eat the cherry.",
                    icon: "point.topleft.down.curvedto.point.bottomright.up",
                    isAvailable: true)
        case .DinoRun:
            GameInfo(title: "Dino Run",
                     note: "Classic Chrome offline game.",
                     icon: "figure.gymnastics",
                     isAvailable: true)
        case .Flappy:
            GameInfo(title: "Flappy Bird",
                     note: "Tap to flap, dodge the pipes.",
                     icon: "bird.fill",
                     isAvailable: true)
        case .Orbit_Dodge:
            GameInfo(title: "Orbit Dodge",
                     note: "Dodge incoming comets. Tap to reverse orbit.",
                     icon: "moonphase.full.moon",
                     isAvailable: true)
        case .ComingSoon:
            GameInfo(title: "Mini Game",
                    note: "Coming soon...",
                    icon: "gamecontroller",
                    isAvailable: false)
        }
    }

    @ViewBuilder
    func destination() -> some View {
        destinationView()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(info.title)
                        .font(.retroGameTitle3)
                        .foregroundStyle(ThemeGradient.accentVertical)
                }
            }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        switch self {
        case .commitSnake:
            CommitSnakeGame()
        case .DinoRun:
            DinoRunView()
        case .Flappy:
            FlappyBird()
        case .Orbit_Dodge:
            OrbitDodge()
        case .ComingSoon:
            Text("Coming Soon!")
        }
    }
}



