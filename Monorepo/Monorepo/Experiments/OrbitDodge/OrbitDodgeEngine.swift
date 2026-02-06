//
//  OrbitDodgeEngine.swift
//  Monorepo
//
//  Created by codeAlligator on 06/02/26.
//

import SwiftUI
import Observation

/// The core game engine for OrbitDodge.
@Observable @MainActor
final class OrbitDodgeEngine {
    // MARK: - Game State
    var state: GameState = .idle
    var score: Double = 0
    var highScore: Double = UserDefaults.standard.double(forKey: "orbit_high_score")

    // MARK: - Physics Properties
    /// The current rotation of the player in radians.
    var angle: CGFloat = 0
    /// Determines orbital direction: 1 for clockwise, -1 for counter-clockwise.
    var direction: CGFloat = 1
    /// Active enemies currently moving toward the center.
    var enemies: [Enemy] = []
    /// The actual size of the playable Canvas, synced from the View.
    var canvasSize: CGSize = .zero
    
    // MARK: - Constants & Tuning
    let orbitRadius: CGFloat = 120
    let playerSize: CGFloat = 40
    let enemySize: CGFloat = 30
    let rotationSpeed: CGFloat = 2.2 // Radians per second
    let enemySpeed: CGFloat = 180    // Points per second
    
    // MARK: - Computed Properties
    /// Radii used for precise circular collision detection.
    var playerRadius: CGFloat { playerSize / 2 }
    var enemyRadius: CGFloat { enemySize / 2 }

    // MARK: - Core Game Loop
    /// Updates game logic for a single frame.
    /// - Parameter dt: Delta time (time elapsed since last frame).
    func update(dt: CGFloat) {
        // Halt logic if not playing or if view bounds aren't yet known
        guard state == .playing, canvasSize != .zero else { return }

        // 1. Update Player position based on speed and direction
        angle += dt * rotationSpeed * direction
        
        // 2. Update Enemy positions and perform memory cleanup.
        // We use compactMap to "recycle" the array: if an enemy passes the center (-20),
        // it returns nil and is removed from memory, preventing an infinite array leak.
        enemies = enemies.compactMap { enemy in
            var updated = enemy
            updated.distance -= dt * enemySpeed
            return updated.distance > -20 ? updated : nil
        }

        // 3. Procedural Spawning
        spawnEnemyIfNeeded()

        // 4. Collision Detection
        let center = CGPoint(x: canvasSize.width/2, y: canvasSize.height/2)
        if checkCollision(center: center) {
            endGame()
        }

        // 5. Scoring (Time-based survival)
        score += dt
    }

    // MARK: - Spawning Logic
    /// Randomly spawns a new enemy from the screen edge.
    private func spawnEnemyIfNeeded() {
        // Approx. 1 in 50 chance per frame (1.2 enemies per second at 60fps)
        if Int.random(in: 0...50) == 0 {
            let spawnDist = max(canvasSize.width, canvasSize.height)
            enemies.append(Enemy(
                angle: CGFloat.random(in: 0...(2 * .pi)),
                distance: spawnDist
            ))
        }
    }

    // MARK: - Physics & Collision
    /// Calculates if the player and any enemy overlap using circular math.
    private func checkCollision(center: CGPoint) -> Bool {
        // Resolve Player's X/Y coordinates from Polar coordinates (angle/radius)
        let playerPos = CGPoint(
            x: center.x + cos(angle) * orbitRadius,
            y: center.y + sin(angle) * orbitRadius
        )

        for enemy in enemies {
            // Resolve Enemy's X/Y coordinates
            let enemyPos = CGPoint(
                x: center.x + cos(enemy.angle) * enemy.distance,
                y: center.y + sin(enemy.angle) * enemy.distance
            )

            //Optimization: Use hypot() for the distance between two points.
            // It is more numerically stable than sqrt(dx*dx + dy*dy).
            let dist = hypot(enemyPos.x - playerPos.x, enemyPos.y - playerPos.y)
            
            // Check if distance is less than sum of both radii (Collision!)
            if dist < (playerRadius + enemyRadius) { return true }
        }
        return false
    }
    
    // MARK: - Lifecycle & Input
    /// Triggers the appropriate logic based on current game state.
    func tapAction() {
        switch state {
        case .idle, .gameOver:
            restart()
        case .playing:
            // Invert orbital movement
            direction *= -1
        }
    }

    /// Transitions to the game over state and persists high score.
    private func endGame() {
        state = .gameOver
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "orbit_high_score")
        }
        // Haptic Feedback for the crash
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    /// Resets the engine to a fresh state for a new session.
    private func restart() {
        enemies.removeAll()
        score = 0
        angle = 0
        direction = 1
        state = .playing
    }
}
