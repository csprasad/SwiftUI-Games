//
//  OrbitDodgeEngine.swift
//  Monorepo
//
//  Created by codeAlligator on 06/02/26.
//

import SwiftUI
import Observation

/// Core game engine for OrbitDodge.
@Observable @MainActor
final class OrbitDodgeEngine {
    // MARK: - Game State
    var state: GameState = .idle
    var score: Double = 0
    var highScore: Double = UserDefaults.standard.double(forKey: "orbit_high_score")

    // MARK: - Physics Properties
    /// Player rotation in radians.
    var angle: CGFloat = 0
    /// Orbital direction: 1 = clockwise, -1 = counter-clockwise.
    var direction: CGFloat = 1
    /// Active enemies moving toward the center.
    var enemies: [Enemy] = []
    /// Canvas size synced from the View.
    var canvasSize: CGSize = .zero
    
    // MARK: - Constants & Tuning
    let orbitRadius: CGFloat = 120
    let playerSize: CGFloat = 40
    let enemySize: CGFloat = 30
    let rotationSpeed: CGFloat = 2.2
    let enemySpeed: CGFloat = 180
    
    // MARK: - Computed Properties
    /// Radii used for circular collision detection.
    var playerRadius: CGFloat { playerSize / 2 }
    var enemyRadius: CGFloat { enemySize / 2 }

    // MARK: - Core Game Loop
    /// Advances simulation by delta time.
    func update(dt: CGFloat) {
        // Halt logic if not playing or layout not ready
        guard state == .playing, canvasSize != .zero else { return }

        angle += dt * rotationSpeed * direction
        
        // CompactMap keeps array bounded by removing enemies past center.
        enemies = enemies.compactMap { enemy in
            var updated = enemy
            updated.distance -= dt * enemySpeed
            return updated.distance > -20 ? updated : nil
        }

        spawnEnemyIfNeeded()

        let center = CGPoint(x: canvasSize.width/2, y: canvasSize.height/2)
        if checkCollision(center: center) {
            endGame()
        }

        score += dt
    }

    // MARK: - Spawning Logic
    /// Random edge spawning (~1 in 50 chance per frame).
    private func spawnEnemyIfNeeded() {
        if Int.random(in: 0...50) == 0 {
            let spawnDist = max(canvasSize.width, canvasSize.height)
            enemies.append(Enemy(
                angle: CGFloat.random(in: 0...(2 * .pi)),
                distance: spawnDist
            ))
        }
    }

    // MARK: - Physics & Collision
    /// Circular collision check using distance between centers.
    private func checkCollision(center: CGPoint) -> Bool {
        let playerPos = CGPoint(
            x: center.x + cos(angle) * orbitRadius,
            y: center.y + sin(angle) * orbitRadius
        )

        for enemy in enemies {
            let enemyPos = CGPoint(
                x: center.x + cos(enemy.angle) * enemy.distance,
                y: center.y + sin(enemy.angle) * enemy.distance
            )

            // hypot() is numerically stable for distance calculation.
            let dist = hypot(enemyPos.x - playerPos.x, enemyPos.y - playerPos.y)
            
            if dist < (playerRadius + enemyRadius) { return true }
        }
        return false
    }
    
    // MARK: - Lifecycle & Input
    /// Handles tap depending on current state.
    func tapAction() {
        switch state {
        case .idle, .gameOver:
            restart()
        case .playing:
            direction *= -1
        }
    }

    /// Ends session and persists high score.
    private func endGame() {
        state = .gameOver
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "orbit_high_score")
        }
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    /// Resets engine to initial play state.
    private func restart() {
        enemies.removeAll()
        score = 0
        angle = 0
        direction = 1
        state = .playing
    }
}
