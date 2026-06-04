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

private struct Stone: Identifiable {
    let id: Int
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
}

private let groundStones: [Stone] = (0..<60).map { index in
    let seed = CGFloat(index * 137 + 42)

    return Stone(
        id: index,
        x: seed * 23,
        y: (seed * 7).truncatingRemainder(dividingBy: 8),
        width: (seed * 3).truncatingRemainder(dividingBy: 6) + 2,
        height: (seed * 5).truncatingRemainder(dividingBy: 3) + 1
    )
}

/// Renders the ground strip used by the game, including a top baseline and a horizontally scrolling field of small stones.
/// - Parameter offset: Horizontal scroll offset (in points) applied to stone positions; values outside the view width wrap around horizontally.
/// - Returns: A view containing the ground baseline and a row of stones that scroll horizontally according to `offset`.
private func dinoGround(offset: CGFloat) -> some View {
    VStack(spacing: 2) {
        // Top solid line
        Rectangle()
            .fill(.primary.opacity(0.5))
            .frame(height: 2)

        // Scrolling stones
        GeometryReader { geo in
            let totalWidth = geo.size.width

            ForEach(groundStones) { stone in
                let scrolledX = (stone.x + offset)
                    .truncatingRemainder(dividingBy: totalWidth)

                let finalX = scrolledX < 0
                    ? scrolledX + totalWidth
                    : scrolledX

                RoundedRectangle(cornerRadius: 1)
                    .fill(
                        .primary.opacity(
                            Double(
                                (stone.width * 13)
                                    .truncatingRemainder(dividingBy: 4) + 1
                            ) * 0.08
                        )
                    )
                    .frame(
                        width: stone.width,
                        height: stone.height
                    )
                    .position(
                        x: finalX,
                        y: stone.y + 4
                    )
            }
        }
        .frame(height: 14)
        .clipped()
    }
    .frame(maxWidth: .infinity)
    .frame(height: 20)
}
