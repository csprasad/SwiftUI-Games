//
//  DinoRunView.swift
//  Monorepo
//
//  Created by codeAlligator on 31/01/26.
//

import SwiftUI

struct DinoRunView: View {
    @State private var engine = DinoEngine()
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: HUD
            HStack(spacing: 10) {
                Text("HI")
                    .font(.retroGameTitle3)
                
                Text("\(String(format: "%05d", engine.highScore))")
                    .font(.retroGameTitle3)
                
                Text(String(format: "%05d", engine.deciSeconds))
                    .font(.retroGameTitle3)
                
                Spacer()
                
                Text(String(format: "%.1fx", engine.speedMultiplier))
                    .font(.retroGameHeadline)
            }
            .foregroundStyle(.primary.opacity(0.7))
            .padding(.top, 100)
            .padding(.horizontal)
            
            // MARK: Game Stage
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.secondary.opacity(0.3))
                    .frame(height: 2)
                
                ForEach(engine.obstacles) { obstacle in
                    HStack(spacing: -10) {
                        ForEach(0..<obstacle.count, id: \.self) { _ in
                            Text("🌵")
                                .font(.system(size: 40))
                        }
                    }
                    .offset(x: obstacle.xPos, y: 7)
                }
                
                Text("🦖")
                    .font(.system(size: 50))
                    .scaleEffect(x: -1, y: 1)
                    .offset(x: engine.dinoXPosition, y: engine.dinoYOffset + 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture { engine.handleButtonTap() }
            .drawingGroup()
            .clipped()
            .overlay(alignment: engine.state == .idle ? .bottom : .top) {
                if engine.state == .idle || engine.state == .gameOver {
                    GameOverView(state: engine.state)
                        .padding(engine.state == .idle ? .bottom : .top, 60)
                }
            }
            
        }
        // Game loop (60 FPS)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 16_000_000)
                if engine.state == .playing {
                    engine.update(currentInstant: .now)
                }
            }
        }
    }
}

#Preview {
    DinoRunView()
}
