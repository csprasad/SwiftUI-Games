//
//  DinoRunView.swift
//  Monorepo
//
/// Created by `C S Prasad` on `31/01/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

struct DinoRunView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var engine = DinoEngine()
    
    var body: some View {
        ZStack {
            
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
                .padding(.top, 40)
                .padding(.horizontal)
                
                // MARK: Game Stage
                ZStack(alignment: .bottom) {
                    dinoGround(offset: engine.bgOffset)
                    
                    ForEach(engine.obstacles) { obstacle in
                        HStack(spacing: -10) {
                            ForEach(0..<obstacle.count, id: \.self) { _ in
                                Text("🌵")
                                    .font(.system(size: 50))
                            }
                        }
                        .offset(x: obstacle.xPos, y: -3)
                    }
                    
                    Text("🦖")
                        .font(.system(size: 60))
                        .scaleEffect(x: -1, y: 1)
                        .offset(x: engine.dinoXPosition, y: engine.dinoYOffset + 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .drawingGroup()
                .clipped()
                .overlay(alignment: engine.state == .idle ? .bottom : .top) {
                    if engine.state == .idle || engine.state == .gameOver {
                        GameOverView(state: engine.state)
                            .padding(engine.state == .idle ? .bottom : .top, 60)
                    }
                }
                .onTapGesture { engine.handleButtonTap() }
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
        .background(colorScheme == .dark ? .black : .white)
        
    }
}

private func dinoGround(offset: CGFloat) -> some View {
    VStack(spacing: 2) {
        // Top solid line
        Rectangle()
            .fill(.primary.opacity(0.5))
            .frame(height: 2)
        
        // Scrolling stones
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let stones: [(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat)] = (0..<60).map { i in
                let seed = CGFloat(i * 137 + 42)
                return (
                    x: (seed * 23).truncatingRemainder(dividingBy: totalWidth),
                    y: (seed * 7).truncatingRemainder(dividingBy: 8),
                    w: (seed * 3).truncatingRemainder(dividingBy: 6) + 2,
                    h: (seed * 5).truncatingRemainder(dividingBy: 3) + 1
                )
            }
            
            ForEach(0..<stones.count, id: \.self) { i in
                let s = stones[i]
                // wrap x position within totalWidth using offset
                let scrolledX = (s.x + offset)
                    .truncatingRemainder(dividingBy: totalWidth)
                // handle negative remainder
                let finalX = scrolledX < 0 ? scrolledX + totalWidth : scrolledX
                
                RoundedRectangle(cornerRadius: 1)
                    .fill(.primary.opacity(
                        Double((s.w * 13).truncatingRemainder(dividingBy: 4) + 1) * 0.08
                    ))
                    .frame(width: s.w, height: s.h)
                    .position(x: finalX, y: s.y + 4)
            }
        }
        .frame(height: 14)
        .clipped()
    }
    .frame(maxWidth: .infinity)
    .frame(height: 20)
}

#Preview {
    DinoRunView()
}
