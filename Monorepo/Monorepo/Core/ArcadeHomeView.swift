//
//  ArcadeHomeView.swift
//  Monorepo
//
//  Created by codeAlligator on 30/01/26.
//

import SwiftUI

struct ArcadeHomeView: View {
    let games: [GameRoute] = [.commitSnake, .DinoRun, .Flappy, .Orbit_Dodge, .ComingSoon]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Arcade Header
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 6) {
                        Text("SWIFTUI")
                            .font(.retroGameLargeTitle)
                            .kerning(4)
                            .foregroundStyle(ThemeGradient.accentVertical)
                        
                        Image(systemName: "dice")
                            .font(.retroGameTitle2)
                            .foregroundStyle(ThemeGradient.accentVertical)
                    }
                    
                    Text("ARCADE GAMES")
                        .font(.retroGaming(size: 13))
                        .foregroundStyle(.orange.opacity(0.9))
                    
                    Rectangle()
                        .frame(maxHeight: 1)
                        .foregroundStyle(ThemeGradient.accentHorizontal)
                }
                .padding(.horizontal, 30)
                .padding(.vertical)
                
                // Game List
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(games) { game in
                            NavigationLink(value: game) {
                                ArcadeCard(game: game)
                            }
                            .buttonStyle(.plain)
                            .disabled(!game.info.isAvailable)
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationDestination(for: GameRoute.self) { route in
                    route.destination()
                }
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    ArcadeHomeView()
}
