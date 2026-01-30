//
//  ArcadeHomeView.swift
//  Monorepo
//
//  Created by codeAlligator on 30/01/26.
//

import SwiftUI

struct ArcadeHomeView: View {
    let games: [GameRoute] = [.commitSnake, .mamal]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("SwiftUI Arcade")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)

                List(games) { game in
                    NavigationLink(value: game) {
                        HStack(spacing: 16) {
                            Image(systemName: game.info.icon)
                                .font(.title2)
                                .foregroundStyle(game.info.isAvailable ? .green : .gray)
                            
                            VStack(alignment: .leading) {
                                Text(game.info.title)
                                    .font(.headline)
                                Text(game.info.note)
                                    .font(.caption)
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
