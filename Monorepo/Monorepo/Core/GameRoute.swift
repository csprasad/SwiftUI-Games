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
    
    var id: Self { self }
    
    var info: GameInfo {
        switch self {
        case .commitSnake:
            GameInfo(title: "Commit Snake",
                    note: "GitHub graph & Trackball controls",
                    icon: "point.topleft.down.curvedto.point.bottomright.up",
                    isAvailable: true)
        case .DinoRun:
            GameInfo(title: "Dino Run",
                     note: "Chrome offline dinosaur jump",
                     icon: "figure.gymnastics",
                     isAvailable: true)
        case .ComingSoon:
            GameInfo(title: "Mini Game",
                    note: "Coming soon",
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
                        .font(.bungeeSpiceTitle3)
                }
            }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        switch self {
        case .commitSnake:
            CommitSnakeGame()
        case .DinoRun:
            DinoRunGame()
        case .ComingSoon:
            Text("Coming Soon!")
        }
    }
}
