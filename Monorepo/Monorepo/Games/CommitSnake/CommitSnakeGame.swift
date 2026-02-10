//
//  CommitSnakeGame.swift
//  Monorepo
//
//  Created by codeAlligator on 30/01/26.
//

import SwiftUI

struct CommitSnakeGame: View {
    @State private var engine = CommitSnakeEngine()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                // HUD Space: Leave room for the floating glass HUD
                Spacer()
                    .frame(height: 50)
                
                //Grid: occupies available space
                CommitGridView(engine: engine)
                    .layoutPriority(1) // Ensures the grid gets space first
                
                // Controller Area: Fixed at the bottom
                TrackballView(engine: engine)
                    .frame(height: 100)
                    .padding(.bottom, 20)
            }

            // HUD: Scoreboard floats on top using ZStack alignment
            GlassEffectContainer {
                HStack {
                    Text("COMMITS")
                        .font(.bungeeHeadline)
                        .foregroundStyle(.primary.opacity(0.75))
                    
                    Text("\(engine.snakeBody.count - 3)")
                        .font(.retroGameHeadline) //bungeeHeadline
                        .foregroundStyle(Color.green)
                    Spacer()
                    Text("Level")
                        .font(.bungeeHeadline)
                        .foregroundStyle(.primary.opacity(0.75))
                    
                    Text("\(engine.snakeBody.count / 5)")
                        .font(.retroGameHeadline)
                        .foregroundStyle(Color.green)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .padding()
        }
        .task {
            // Check for cancellation at the start of every loop iteration
            while !engine.isGameOver && !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 150_000_000)
                
                // Final check before executing logic to prevent a "zombie" move
                if !Task.isCancelled {
                    engine.move()
                }
            }
        }
    }
}

#Preview {
    CommitSnakeGame()
}
