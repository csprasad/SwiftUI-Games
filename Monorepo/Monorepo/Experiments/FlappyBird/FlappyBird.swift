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
            // MARK: HUD
            HStack {
                // High score display
                Text("HI \(engine.highScore)")
                    .font(.bungeeTitle3)
                
                Spacer()
                
                // Current score with numeric animation
                Text("\(engine.score)")
                    .font(.bungeeSpiceTitle2)
                    .contentTransition(.numericText())
                    .animation(.spring(duration: 0.2), value: engine.score)
            }
            .foregroundStyle(.primary.opacity(0.7))
            .padding()
            
            // MARK: Game Stage (Main Viewport)
            ZStack {
                // Bird emoji based on color scheme
                let bird: String = (colorScheme == .dark ? "🐤" : "🐧")
                
                // MARK: Scrolling Background
                // Infinite scrolling using two copies side by side
                ZStack {
                    // First copy: Primary background
                    backgroundDecorations(for: colorScheme)
                        .offset(x: engine.bgOffset)
                    
                    // Second copy: Seamless loop continuation
                    backgroundDecorations(for: colorScheme)
                        .offset(x: engine.bgOffset + 400) // Match loopWidth in engine
                }
                
                // MARK: Pipes
                // Dynamically rendered obstacles
                ForEach(engine.pipes) { pipe in
                    Group {
                        // Top pipe (hanging down)
                        pipeView(height: 500)
                            .offset(x: pipe.xPos, y: pipe.gapTop - 250)
                        
                        // Bottom pipe (standing up)
                        pipeView(height: 500)
                            .offset(x: pipe.xPos, y: pipe.gapTop + 420)
                    }
                }
                
                // MARK: Bird
                // Player character with physics-based vertical movement
                Text(bird)
                    .font(.system(size: 45))
                    .offset(y: engine.birdY)
                    .scaleEffect(x: -1, y: 1) // Flip horizontally for direction
                    .shadow(radius: 4, y: 4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .drawingGroup() // Performance optimization: renders as single layer
            .clipped() // Prevents overflow outside game bounds
            .border(width: 1, edges: [.top, .bottom], color: .secondary.opacity(0.2))
            
            // MARK: Floor Limit Detection
            // Dynamically calculate ground collision boundary
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.height / 2 // Distance from center to bottom edge
            } action: { newValue in
                engine.floorLimit = newValue - 25 // Adjust for bird height
            }
            
            // MARK: Game Over / Start Overlay
            .overlay {
                if engine.state == .idle || engine.state == .gameOver {
                    ZStack {
                        GameOverView(state: engine.state)
                            .padding(30)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
                            .frame(
                                maxHeight: .infinity,
                                alignment: engine.state == .idle ? .bottom : .center
                            )
                            .padding(.bottom, engine.state == .idle ? 80 : 0)
                            .padding(.horizontal, 40)
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .bottom) // Extend to screen bottom
        .contentShape(Rectangle()) // Make entire area tappable
        
        // MARK: Tap Gesture
        // Primary game interaction: flap to fly
        .onTapGesture {
            engine.handleTap()
        }
        
        // MARK: Game Loop
        // 60 FPS update cycle (~16ms per frame)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 16_000_000) // ~60 FPS
                engine.update()
            }
        }
    }
    
    // MARK: - Pipe View Component
    /// Creates a styled pipe obstacle with gradient and glass effect
    /// - Parameter height: Vertical size of the pipe
    @ViewBuilder
    private func pipeView(height: CGFloat) -> some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [
                        .yellow,
                        .orange.opacity(0.8),
                        .red.opacity(0.8)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 65, height: height)
            .overlay(
                Capsule()
                    .stroke(.secondary.opacity(0.3), lineWidth: 2)
            )
    }
}

// MARK: - Background Decorations
/// Renders ambient decorations (clouds, celestial objects, waves)
/// Adapts visuals based on light/dark mode
/// - Parameter scheme: Current color scheme (light/dark)
@ViewBuilder
private func backgroundDecorations(for scheme: ColorScheme) -> some View {
    // Theme aware symbols
    let isDark = scheme == .dark
    let dayNightIcon: String = isDark ? "☾" : "☼"
    let dayStarIcon: String = isDark ? "ᯓ" : "𓂃ོ"
    let clouds: String = isDark ? "⋆˚☆˖°⋆｡° ✮˖ ࣪ ⊹" : "⋆｡ﾟ☁︎｡⋆𓂃 ོ𓂃"
    let waves: String = "𓏲𓂃𓂃𓂃.˚﹏𓊝﹏ 𓂁﹏ ࣪ ﹏𓆝﹏𓆟﹏𓆞﹏𓆝﹏𓆟﹏﹏𓂁˚﹏﹏﹏𓅸﹏ ﹏ ﹏﹏ ﹏﹏ 𓊝﹏ ﹏ ﹏﹏﹏𓂁 ﹏﹏﹏﹏﹏ 𓏲𓂃𓂃𓂃𓊞﹏ ﹏ ﹏﹏ ܸ.ˬ. ܸ ﹏﹏ ﹏﹏  ܸ.ˬ. ܸ ﹏﹏"
    let skyColor: Color = isDark ? .gray : .black
    
    Group {
        // Upper decorative clouds
        Text(clouds)
            .font(.system(size: 60))
            .offset(x: 100, y: -310)
            .opacity(0.6)
        
        // Left cloud
        Text("☁️")
            .font(.system(size: 60))
            .offset(x: -140, y: -250)
            .opacity(0.3)
        
        // Celestial centerpiece (moon/sun with stars)
        Text("\(dayStarIcon) \(dayNightIcon) \(dayStarIcon)")
            .font(.system(size: 90))
            .offset(x: 0, y: -190)
            .opacity(0.6)
        
        // Right cloud
        Text("☁️")
            .font(.system(size: 80))
            .offset(x: 110, y: -120)
            .opacity(0.3)
        
        // Bottom wave pattern (ocean/ground decoration)
        Text(waves)
            .font(.system(size: 35))
            .lineLimit(6)
            .lineSpacing(10)
            .offset(x: 0, y: 200)
            .opacity(0.8)
    }
    .foregroundStyle(skyColor.opacity(0.9))
    .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 2)
    .allowsHitTesting(false) // Performance: prevent touch handling
    .drawingGroup() // Performance: render as single bitmap layer
}

// MARK: - Preview
#Preview {
    FlappyBird()
}
