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
    case mamal
    
    var id: Self { self }
    
    var info: GameInfo {
        switch self {
        case .commitSnake:
            GameInfo(
                title: "Commit Snake",
                note: "GitHub graph & Trackball controls",
                icon: "point.topleft.down.curvedto.point.bottomright.up",
                isAvailable: true
            )
        case .mamal:
            GameInfo(
                title: "Mamal Game",
                note: "Coming soon",
                icon: "gamecontroller",
                isAvailable: false
            )
        }
    }

    @ViewBuilder
    func destination() -> some View {
        destinationView()
            .navigationTitle(info.title)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        switch self {
        case .commitSnake:
            CommitSnakeGame()
        case .mamal:
            Text("Coming Soon!")
        }
    }
}
