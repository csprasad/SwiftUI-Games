//
//  FlappyBird.swift
//  Monorepo
//
/// Created by `C S Prasad` on `03/02/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

struct FlappyBird: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var engine = FlappyEngine()

    var body: some View {
        VStack(spacing: 0) {
            // MARK: Game Stage
            ZStack {
                // Infinite scrolling background
                ZStack {
                    decoration(for: (colorScheme == .dark ? "flappyBg-Dark" : "flappyBg-Lite"), offset: engine.bgOffset)
                }
                
                // Pipes
                ForEach(engine.pipes) { pipe in
                    Group {
                        pipeView(height: 500, isTopPipe: true)
                            .offset(x: pipe.xPos, y: pipe.gapTop - 250)
                        
                        pipeView(height: 500, isTopPipe: false)
                            .offset(x: pipe.xPos, y: pipe.gapTop + 420)
                    }
                }
                
                // Bird
                Text("🐤")
                    .font(.system(size: 50))
                    .offset(y: engine.birdY)
                    .scaleEffect(x: -1, y: 1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .drawingGroup()
            .clipped()
            .border(width: 1, edges: [.top, .bottom], color: .secondary.opacity(0.2))
            
            // Floor collision boundary derived from geometry
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.height / 2
            } action: { newValue in
                engine.floorLimit = newValue - 25
            }
            .overlay(alignment: .top) {
                // MARK: HUD
                HStack(alignment: .top) {
                    Text("HI \(engine.highScore)")
                        .font(.retroGameTitle)
                    
                    Spacer()
                    
                    Text("\(engine.score)")
                        .font(.retroGameTitle)
                        .contentTransition(.numericText())
                        .animation(.spring(duration: 0.2), value: engine.score)
                }
                .foregroundStyle(.primary.opacity(0.7))
                .padding(.top, 180)
                .padding(.horizontal)
                .frame(height: 100)
            }
            .overlay(alignment: engine.state == .idle ? .bottom : .center) {
                // Bottom for idle, top for game over
                if engine.state == .idle || engine.state == .gameOver {
                    GameOverView(state: engine.state)
                        .padding(engine.state == .idle ? .bottom : .top, 60)
                }
            }
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture { engine.handleTap() }
        
        // Fixed-step game loop (~60 FPS)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 16_000_000)
                engine.update()
            }
        }
    }
    
    // MARK: - Pipe View
    /// Styled pipe obstacle.
    @ViewBuilder
    private func pipeView(height: CGFloat, isTopPipe: Bool) -> some View {
        VStack(spacing: 0) {
            // Cap for bottom pipes
            if !isTopPipe { pipeCap }
                        
            // Pipe
            Rectangle()
                .fill(ThemeGradient.pixelPipeGradient(for: colorScheme))
                .frame(width: 50, height: height - 25)
            
            // Cap for top pipes
            if isTopPipe { pipeCap }
        }
    }

    // Reusable Pipe Cap
    private var pipeCap: some View {
        Rectangle()
            .fill(ThemeGradient.pixelPipeGradient(for: colorScheme))
            .frame(width: 65, height: 25)
            .overlay(
                Rectangle()
                    .stroke(.black.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    FlappyBird()
}
