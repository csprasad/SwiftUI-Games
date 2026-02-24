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
                let bird: String = (colorScheme == .dark ? "🐤" : "🐧")
                // Infinite scrolling background
                ZStack {
                    backgroundDecorations(for: colorScheme)
                        .offset(x: engine.bgOffset)
                    
                    backgroundDecorations(for: colorScheme)
                        .offset(x: engine.bgOffset + 400)
                }
                
                // Pipes
                ForEach(engine.pipes) { pipe in
                    Group {
                        pipeView(height: 500)
                            .offset(x: pipe.xPos, y: pipe.gapTop - 250)
                        
                        pipeView(height: 500)
                            .offset(x: pipe.xPos, y: pipe.gapTop + 420)
                    }
                }
                
                // Bird
                Text(bird)
                    .font(.system(size: 45))
                    .offset(y: engine.birdY)
                    .scaleEffect(x: -1, y: 1)
                    .shadow(radius: 4, y: 4)
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
                        .font(.retroGameTitle3)
                    
                    Spacer()
                    
                    Text("\(engine.score)")
                        .font(.retroGameTitle3)
                        .contentTransition(.numericText())
                        .animation(.spring(duration: 0.2), value: engine.score)
                }
                .foregroundStyle(.primary.opacity(0.7))
                .padding(.top, 200)
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
    private func pipeView(height: CGFloat) -> some View {
        Capsule()
            .fill(ThemeGradient.accentHorizontal.opacity(0.8))
            .frame(width: 65, height: height)
            .overlay(
                Capsule()
                    .stroke(.secondary.opacity(0.3), lineWidth: 2)
            )
    }
}

// MARK: - Background Decorations
/// Theme-aware ambient background elements.
@ViewBuilder
private func backgroundDecorations(for scheme: ColorScheme) -> some View {
    let isDark = scheme == .dark
    let dayNightIcon: String = isDark ? "☾" : "☼"
    let dayStarIcon: String = isDark ? "ᯓ" : "𓂃ོ"
    let clouds: String = isDark ? "⋆˚☆˖°⋆｡° ✮˖ ࣪ ⊹" : "⋆｡ﾟ☁︎｡⋆𓂃 ོ𓂃"
    let waves: String = "𓏲𓂃𓂃𓂃.˚﹏𓊝﹏ 𓂁﹏ ࣪ ﹏𓆝﹏𓆟﹏𓆞﹏𓆝﹏𓆟﹏﹏𓂁˚﹏﹏﹏𓅸﹏ ﹏ ﹏﹏ ﹏﹏ 𓊝﹏ ﹏ ﹏﹏﹏𓂁 ﹏﹏﹏﹏﹏ 𓏲𓂃𓂃𓂃𓊞﹏ ﹏ ﹏﹏ ܸ.ˬ. ܸ ﹏﹏ ﹏﹏  ܸ.ˬ. ܸ ﹏﹏"
    let skyColor: Color = isDark ? .gray : .black
    
    Group {
        Text(clouds)
            .font(.retroGaming(size: 50))
            .offset(x: 100, y: -310)
        
        Text("☁️")
            .font(.retroGaming(size: 60))
            .offset(x: -140, y: -250)
        
        Text("\(dayStarIcon) \(dayNightIcon) \(dayStarIcon)")
            .font(.retroGaming(size: 70))
            .offset(x: 0, y: -190)
        
        Text("☁️")
            .font(.retroGaming(size: 60))
            .offset(x: 110, y: -120)
        
        Text(waves)
            .font(.retroGaming(size: 35))
            .lineLimit(6)
            .lineSpacing(10)
            .offset(x: 0, y: 200)
    }
    .opacity(0.3)
    .foregroundStyle(skyColor.opacity(0.9))
    .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 2)
    .allowsHitTesting(false)
    .drawingGroup()
}

#Preview {
    FlappyBird()
}
