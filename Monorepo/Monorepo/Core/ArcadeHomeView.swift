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
                VStack(spacing: 4) {
                    HStack(spacing: 16) {
                            Image(systemName: "gamecontroller.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.yellow, .orange, .red],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            
                            Text("Nano Repo")
                                .font(.bungeeSpiceLargeTitle)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.green, .white, .green],
                                        startPoint: .topTrailing,
                                        endPoint: .bottomLeading
                                    )
                                )
                            
                            Image(systemName: "gamecontroller.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.yellow, .orange, .red],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        }
                    
                    Text("ARCADE GAMES")
                        .font(.bungeeBody)
                        .foregroundStyle(.orange.opacity(0.9))
                    
                    Rectangle()
                        .frame(maxHeight: 0.5)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.clear, .orange, .clear],
                                startPoint: .trailing,
                                endPoint: .leading
                            )
                        )
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                // Game List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(games) { game in
                            NavigationLink(value: game) {
                                ArcadeCard(game: game)
                            }
                            .disabled(!game.info.isAvailable)
                        }
                    }
                    .padding(.horizontal, 8)
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
