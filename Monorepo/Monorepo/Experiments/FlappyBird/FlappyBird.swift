//
//  FlappyBird.swift
//  Monorepo
//
//  Created by codeAlligator on 03/02/26.
//

import SwiftUI

struct FlappyBird: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var engine = FlappyEngine()
    
    var body: some View {
            VStack(spacing: 0) {
                // HUD
                HStack() {
                    Text("HI \(engine.highScore)")
                        .font(.bungeeTitle3)
                    Spacer()
                    Text("\(engine.score)")
                        .font(.bungeeSpiceTitle3)
                        .contentTransition(.numericText())
                        .animation(.spring(duration: 0.2), value: engine.score)
                }
                .foregroundStyle(.primary.opacity(0.7))
                .padding()
                
                // Game Stage: The Viewport
                ZStack {
                    
                    // Stage Decoration
                        ZStack {
                            // Copy 1: Primary
                            backgroundDecorations(for: colorScheme)
                                .offset(x: engine.bgOffset)
                            
                            // Copy 2: The "Follower" that fills the gap
                            backgroundDecorations(for: colorScheme)
                                .offset(x: engine.bgOffset + 400) // Must match loopWidth
                        }

                    
                    // Pipes: Professional "Capsule" look
                    ForEach(engine.pipes) { pipe in
                        Group {
                            // Top Pipe
                            pipeView(height: 500)
                                .offset(x: pipe.xPos, y: pipe.gapTop - 250)
                            
                            // Bottom Pipe
                            pipeView(height: 500)
                                .offset(x: pipe.xPos, y: pipe.gapTop + 420)
                        }
                    }
                    
                    // The Bird: Dynamic rotation based on velocity
                    Text("🐧")
                        .font(.system(size: 45))
                        .offset(y: engine.birdY)
                        .scaleEffect(x:-1, y: 1)
                        .shadow(radius: 4, y: 4)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .drawingGroup()
//                .ignoresSafeArea()
                .clipped()
                .border(width: 1, edges: [.top, .bottom], color: .secondary.opacity(0.2))
                .onGeometryChange(for: CGFloat.self) { proxy in
                    // proxy.size.height / 2 is the distance from center to bottom
                    proxy.size.height / 2
                } action: { newValue in
                    // Subtract ~25 to account for the bird's own height so it sits ON the line
                    engine.floorLimit = newValue - 25
                }
                .overlay {
                    if engine.state == .idle || engine.state == .gameOver {
                        GameOverView(state: engine.state)
                            .padding(engine.state == .idle ? .bottom : .top, 60)
                    }
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            engine.handleTap()
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 16_000_000)
                    engine.update()
            }
        }
    }
    
    // Helper for styled Pipes
    @ViewBuilder
    private func pipeView(height: CGFloat) -> some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [.yellow, .orange.opacity(0.8), .red.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 65, height: height)
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.3), lineWidth: 2)
            )
    }
}


// 2. Helper accepts the colorScheme as a parameter
@ViewBuilder
private func backgroundDecorations(for scheme: ColorScheme) -> some View {
    let dayNightIcon: String = (scheme == .dark ? "☾" : "☼")
    let dayStarIcon: String = (scheme == .dark ? "ᯓ" : "𓂃ོ")
    let clouds: String = (scheme == .dark ? "⋆˚☆˖°⋆｡° ✮˖ ࣪ ⊹" : "⋆｡ﾟ☁︎｡⋆𓂃 ོ𓂃")
    let skyColor: Color = (scheme == .dark ? .indigo : .orange)
    
    Group {
        Text("\(clouds)")
            .font(.system(size: 60))
            .offset(x: 100, y: -310)
            .opacity(0.6)
        
        Text("☁️")
            .font(.system(size: 60))
            .offset(x: -140, y: -250)
            .opacity(0.3)
        
        Text("\(dayStarIcon) \(dayNightIcon) \(dayStarIcon)")
            .font(.system(size: 90))
            .offset(x: 0, y: -190)
            .opacity(0.6)
        
        Text("☁️")
            .font(.system(size: 80))
            .offset(x: 110, y: -120)
            .opacity(0.3)
        
        Text("𓏲𓂃𓂃𓂃.˚﹏𓊝﹏ 𓂁﹏ ࣪ ﹏𓆝﹏𓆟﹏𓆞﹏𓆝﹏𓆟﹏﹏𓂁˚﹏﹏﹏𓅸﹏ ﹏ ﹏﹏ ﹏﹏ 𓊝﹏ ﹏ ﹏﹏﹏𓂁 ﹏﹏﹏﹏﹏ 𓏲𓂃𓂃𓂃𓊞﹏ ﹏ ﹏﹏ ܸ.ˬ. ܸ ﹏﹏ ﹏﹏  ܸ.ˬ. ܸ ﹏﹏")
            .font(.system(size: 35))
            .offset(x: 0, y: 200)
    }
    .foregroundStyle(skyColor.opacity(0.6))
    .shadow(color: scheme == .dark ? .black : .gray, radius: 10, x: 0, y: 5)
}


#Preview {
    FlappyBird()
}
