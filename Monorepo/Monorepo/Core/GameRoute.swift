//
//  GameRoute.swift
//  Monorepo
//
/// Created by `C S Prasad` on `30/01/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

struct GameInfo {
    var title: String
    var note: String
    var icon: String
    var isAvailable: Bool = true
}

enum GameRoute: Hashable, Identifiable, CaseIterable {
    case commitSnake
    case dinoRun
    case flappyBird
    case orbitDodge
    case comingSoon

    var id: Self { self }

    var info: GameInfo {
        switch self {
        case .commitSnake:
            GameInfo(title: "Commit Snake",
                    note: "Grow your green streak, eat the cherry.",
                    icon: "point.topleft.down.curvedto.point.bottomright.up",
                    isAvailable: true)
        case .dinoRun:
            GameInfo(title: "Dino Run",
                     note: "Classic Chrome offline game.",
                     icon: "figure.gymnastics",
                     isAvailable: true)
        case .flappyBird:
            GameInfo(title: "Flappy Bird",
                     note: "Tap to flap, dodge the pipes.",
                     icon: "bird.fill",
                     isAvailable: true)
        case .orbitDodge:
            GameInfo(title: "Orbit Dodge",
                     note: "Dodge incoming comets. Tap to reverse orbit.",
                     icon: "moonphase.full.moon",
                     isAvailable: true)
        case .comingSoon:
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
        case .dinoRun:
            DinoRunView()
        case .flappyBird:
            FlappyBird()
        case .orbitDodge:
            OrbitDodge()
        case .comingSoon:
            Text("Coming Soon!")
        }
    }
}
