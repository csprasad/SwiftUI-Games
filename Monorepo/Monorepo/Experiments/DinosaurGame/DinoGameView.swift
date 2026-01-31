//
//  DinoRunGame.swift
//  Monorepo
//
//  Created by codeAlligator on 31/01/26.
//

import SwiftUI

struct DinoRunGame: View {
    @State private var engine = DinoEngine()
    
    var body: some View {
        VStack(spacing: 0) {
            // Stats HUD
            HStack {
                // I could have mergerd these 3 Text but spacing didn't make sense so i seperated them;
                /// can be merged
                Text("HI")
                    .font(.bungeeTitle3)
                    .foregroundStyle(.primary.opacity(0.75))
                
                Text("\(String(format: "%05d", engine.highScore))")
                    .font(.bungeeTitle3)
                    .foregroundStyle(.primary.opacity(0.75))
                    .monospacedDigit()
                
                Text(String(format: "%05d", engine.deciSeconds))
                    .font(.bungeeTitle3)
                    .foregroundStyle(.primary.opacity(0.75))
                    .monospacedDigit()
                
                Spacer()
                Text((String(format: "%.1fx", engine.speedMultiplier)))
                    .font(.bungeeSpiceBody)
                    .foregroundStyle(.green.opacity(0.8))
                    .monospacedDigit()
            }
            .padding(.horizontal)
        
            // Viewport (The "Stage")
            ZStack(alignment: .bottom) {
                // Ground
                Rectangle()
                    .fill(.secondary.opacity(0.3))
                    .frame(height: 2)
                
                // Obstacles (Identifiable loop for smooth movement)
                ForEach(engine.obstacles) { obstacle in
                    HStack(spacing: -10) {
                        ForEach(0..<obstacle.count, id: \.self) { _ in
                            Text("🌵")
                                .font(.system(size: 30))
                        }
                    }
                    .offset(x: obstacle.xPos)
                }
                
                // Dino (Anchored Right, Facing Left)
                Text("🦖")
                    .font(.system(size: 40))
                    .offset(x: engine.dinoXPosition, y: engine.dinoYOffset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: engine.state == .idle ? .bottom : .top) {  // Bottom for idle, top for game over
                if engine.state == .idle || engine.state == .gameOver {
                    GameOverView(state: engine.state)
                        .padding(engine.state == .idle ? .bottom : .top, 60)
                }
            }
            .contentShape(Rectangle())  // Make entire area tappable
            .onTapGesture {
                engine.handleButtonTap()
            }
            .drawingGroup() // Essential: Flattens view to GPU for 60FPS
            .clipped()
        }
        .task {
            // High frequency game loop with cancellation safety
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 16_000_000) // ~60fps
                if engine.state == .playing {
                    engine.update(currentInstant: .now)
                }
            }
        }
    }
    
    private var buttonLabel: String {
        switch engine.state {
        case .idle: return "START RUN"
        case .playing: return "JUMP"
        case .gameOver: return "RETRY"
        }
    }
}

#Preview {
    DinoRunGame()
}
