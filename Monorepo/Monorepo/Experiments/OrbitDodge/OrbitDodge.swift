//
//  OrbitDodge.swift
//  Monorepo
//
//  Created by codeAlligator on 06/02/26.
//

import SwiftUI

/// The primary View for OrbitDodge.
/// Utilizes a SwiftUI Canvas for GPU accelerated 2D rendering.
struct OrbitDodge: View {
    /// The Game Engine instance, marked with @State to persist throughout the view's lifecycle.
    @State private var engine = OrbitDodgeEngine()

    var body: some View {
        ZStack {
            // MARK: - Main Game Renderer
            Canvas { context, size in
                // Establish the center point for all radial calculations
                let center = CGPoint(x: size.width/2, y: size.height/2)

                // 1. Resolve Assets
                // We resolve the high-res 512px assets into the context.
                // This prepares the GPU textures for high-speed drawing.
                let playerImg = context.resolve(Image("rocket"))
                let enemyImg = context.resolve(Image("asteroid"))

                // 2. Background Orbit Path
                // Draws a subtle circular guide for the player.
                context.stroke(
                    Path(ellipseIn: CGRect(
                        x: center.x - engine.orbitRadius,
                        y: center.y - engine.orbitRadius,
                        width: engine.orbitRadius*2,
                        height: engine.orbitRadius*2)
                    ),
                    with: .color(.white.opacity(0.1)),
                    lineWidth: 1
                )

                // 3. Player Rendering (The Rocket)
                // Convert Polar coordinates (angle/radius) to Cartesian (x/y) for screen placement.
                let pPos = CGPoint(
                    x: center.x + cos(engine.angle) * engine.orbitRadius,
                    y: center.y + sin(engine.angle) * engine.orbitRadius
                )
                
                // Using drawLayer isolates coordinate transformations (rotation/scale)
                // to just this specific sprite, preventing the rest of the canvas from spinning.
                context.drawLayer { subContext in
                    // Move the 'paper' to the player's current position
                    subContext.translateBy(x: pPos.x, y: pPos.y)
                    
                    // Rotate the sprite so the 'nose' leads the orbital path.
                    // .pi/2 aligns the image's 'Up' direction with the tangent of the circle.
                    subContext.rotate(by: Angle(radians: engine.angle + .pi/2))
                    
                    // Mirror the sprite based on engine direction (1 or -1).
                    // This allows the rocket to visually turn around when reversing orbit.
                    subContext.scaleBy(x: engine.direction, y: 1)
                    
                    // Draw the 512px image scaled down to the engine's playerSize.
                    let s = engine.playerSize
                    subContext.draw(playerImg, in: CGRect(x: -s/2, y: -s/2, width: s, height: s))
                }

                // 4. Enemy Rendering (The Asteroids)
                for enemy in engine.enemies {
                    let ePos = CGPoint(
                        x: center.x + cos(enemy.angle) * enemy.distance,
                        y: center.y + sin(enemy.angle) * enemy.distance
                    )
                    
                    context.drawLayer { subContext in
                        subContext.translateBy(x: ePos.x, y: ePos.y)
                        
                        // Rotates asteroids so they appear to be falling 'head first' toward center.
                        subContext.rotate(by: Angle(radians: enemy.angle + .pi/2))
                        
                        let s = engine.enemySize
                        subContext.draw(enemyImg, in: CGRect(x: -s/2, y: -s/2, width: s, height: s))
                    }
                }
            }
            //Automatically syncs the view's actual size to the engine.
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newSize in
                engine.canvasSize = newSize
            }
            
            // MARK: - Stats HUD UI Layers
            VStack {
                HStack {
                    Text("HI \(Int(engine.highScore))").font(.bungeeTitle3)
                    Spacer()
                    Text("\(Int(engine.score))").font(.bungeeSpiceTitle3)
                }
                .padding(30)
                Spacer()
            }
        }
        .background(Color(white: 0.05))
        .contentShape(Rectangle()) // Ensures the entire screen area is tappable
        .onTapGesture { engine.tapAction() }
        .overlay {
            // Displays Game Over or Start screen card
            if engine.state != .playing {
                GameOverView(state: engine.state)
                    .padding(40)
            }
        }
        // MARK: - Game Tick Loop
        .task {
            // High-efficiency loop running at 60fps.
            // Separating logic (engine.update) from rendering (Canvas) is key for smooth performance.
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
