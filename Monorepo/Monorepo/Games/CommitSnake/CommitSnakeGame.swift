//
//  CommitSnakeGame.swift
//  Monorepo
//
/// Created by `C S Prasad` on `30/01/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

struct CommitSnakeGame: View {
    @State private var engine = CommitSnakeEngine()
    @State private var gameLoopID = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer().frame(height: 50)
                
                CommitGridView(engine: engine)
                    .layoutPriority(1)
                    .overlay(alignment: engine.state == .idle ? .bottom : .top) {
                        if engine.state == .idle || engine.state == .gameOver {
                            GameOverView(state: engine.state)
                                .padding(engine.state == .idle ? .bottom : .top, 60)
                        }
                    }
                    .onTapGesture {
                        handleTrigger()
                    }
                
                TrackballView(engine: engine, onFirstMove: handleTrigger)
                    .frame(height: 100)
                    .padding(.bottom, 20)
            }
            
            GlassEffectContainer {
                HStack {
                    Text("COMMITS")
                        .font(.bungeeHeadline)
                        .foregroundStyle(.primary.opacity(0.75))
                    Text("\(engine.snakeBody.count - 3)")
                        .font(.retroGameHeadline)
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
        .task(id: gameLoopID) {
            while engine.state != .gameOver && !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 150_000_000)
                if !Task.isCancelled {
                    engine.move()
                }
            }
        }
    }
    
    private func handleTrigger() {
        if engine.state == .idle {
            engine.handleButtonTap()
        } else if engine.state == .gameOver {
            engine.handleButtonTap()
            gameLoopID += 1 // restart the task loop
        }
    }
}

#Preview {
    CommitSnakeGame()
}
