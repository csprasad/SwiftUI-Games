//
//  ArcadeHomeView.swift
//  Monorepo
//
//  Created by codeAlligator on 30/01/26.
//

import SwiftUI

struct ArcadeHomeView: View {
    let games: [GameRoute] = [.commitSnake, .DinoRun, .ComingSoon]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("SwiftUI Arcade")
                    .font(.bungeeSpiceLargeTitle)
                    .fontWeight(.heavy)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                
                List(games) { game in
                    NavigationLink(value: game) {
                        HStack(spacing: 8) {
                            Image(systemName: game.info.icon)
                                .font(.bungeeTitle2)
                                .foregroundStyle(game.info.isAvailable ? .orange : .gray)
                            
                            VStack(alignment: .leading) {
                                Text(game.info.title)
                                    .font(.bungeeHeadline)
                                    .foregroundStyle(.primary.opacity(0.75))
                                Text(game.info.note)
                                    .font(.caption)
                                    .fontDesign(.monospaced)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.clear)
                    .disabled(!game.info.isAvailable)
                    .opacity(game.info.isAvailable ? 1 : 0.5)
                }
                // Centralized navigation logic
                .listStyle(.plain)
                .navigationDestination(for: GameRoute.self) { route in
                    route.destination()
                }
                .navigationBarHidden(true)
                .scrollContentBackground(.hidden)
                .background(.clear)
            }
        }
    }
}
