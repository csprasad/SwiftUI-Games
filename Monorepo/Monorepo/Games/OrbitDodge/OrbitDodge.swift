//
//  OrbitDodge.swift
//  Monorepo
//
//  Created by codeAlligator on 06/02/26.
//

import SwiftUI

/// Main game view.
/// Canvas handles rendering, engine handles game logic/state.
struct OrbitDodge: View {
    /// Persisted game engine instance.
    @State private var engine = OrbitDodgeEngine()

    var body: some View {
        ZStack {
            // MARK: - Main Game Renderer
            Canvas { context, size in
                let center = CGPoint(x: size.width/2, y: size.height/2)

                let playerImg = context.resolve(Image("rocket"))
                let enemyImg = context.resolve(Image("asteroid"))

                context.stroke(
                    Path(ellipseIn: CGRect(
                        x: center.x - engine.orbitRadius,
                        y: center.y - engine.orbitRadius,
                        width: engine.orbitRadius*2,
                        height: engine.orbitRadius*2)
                    ),
                    with: .color(.primary.opacity(0.3)),
                    lineWidth: 1
                )

                // Convert polar coordinates to screen position.
                let pPos = CGPoint(
                    x: center.x + cos(engine.angle) * engine.orbitRadius,
                    y: center.y + sin(engine.angle) * engine.orbitRadius
                )
                
                // drawLayer isolates transforms so rotation/scale affect only this sprite.
                context.drawLayer { subContext in
                    subContext.translateBy(x: pPos.x, y: pPos.y)
                    subContext.rotate(by: Angle(radians: engine.angle + .pi/2))
                    subContext.scaleBy(x: engine.direction, y: 1)
                    
                    let s = engine.playerSize
                    subContext.draw(playerImg, in: CGRect(x: -s/2, y: -s/2, width: s, height: s))
                }

                for enemy in engine.enemies {
                    let ePos = CGPoint(
                        x: center.x + cos(enemy.angle) * enemy.distance,
                        y: center.y + sin(enemy.angle) * enemy.distance
                    )
                    
                    context.drawLayer { subContext in
                        subContext.translateBy(x: ePos.x, y: ePos.y)
                        subContext.rotate(by: Angle(radians: enemy.angle + .pi/2))
                        
                        let s = engine.enemySize
                        subContext.draw(enemyImg, in: CGRect(x: -s/2, y: -s/2, width: s, height: s))
                    }
                }
            }
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newSize in
                engine.canvasSize = newSize
            }
            
            // MARK: - Stats HUD UI Layers
            VStack {
                HStack {
                    Text("HI \(Int(engine.highScore))").font(.retroGameTitle3)
                    Spacer()
                    Text("\(Int(engine.score))").font(.retroGameTitle3)
                }
                .padding(30)
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { engine.tapAction() }
        .overlay {
            if engine.state != .playing {
                GameOverView(state: engine.state)
                    .padding(40)
            }
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 16_000_000)
                engine.update(dt: 0.016)
            }
        }
    }
}

#Preview {
    OrbitDodge()
}
