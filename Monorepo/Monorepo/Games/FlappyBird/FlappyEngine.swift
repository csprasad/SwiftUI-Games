//
//  FlappyEngine.swift
//  Monorepo
//
/// Created by `C S Prasad` on `03/02/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Game Model
/// Pipe obstacle defined in polar gameplay space.
struct Pipe: Identifiable {
    let id = UUID()
    var xPos: CGFloat
    var gapTop: CGFloat
    var isScored: Bool = false
}

// MARK: - Game Engine
/// Main game logic controller handling physics, collisions, and state.
@Observable @MainActor
final class FlappyEngine {

    // MARK: - Game State
    var state: GameState = .idle
    var birdY: CGFloat = 0
    var velocity: CGFloat = 0
    var pipes: [Pipe] = []

    // MARK: - Background Parallax
    var bgOffset: CGFloat = 0
    private let bgSpeed: CGFloat = 0.6      // Slower than pipes to create depth
    let loopWidth: CGFloat = 400            // Width before seamless loop reset

    // MARK: - Scoring System
    var score: Int = 0
    var highScore: Int = UserDefaults.standard.integer(forKey: "flappy_high_score")

    // MARK: - Physics Constants
    /// Tuned for smooth, responsive gameplay.
    private let gravity: CGFloat = 0.45
    private let jumpStrength: CGFloat = -8.5
    private let maxFallSpeed: CGFloat = 10.0
    private let pipeSpeed: CGFloat = 4.0
    private let pipeGapHeight: CGFloat = 170.0

    // MARK: - Collision Boundaries
    /// Dynamic floor limit set by view layout.
    var floorLimit: CGFloat = 350

    // MARK: - Interaction Handler
    /// Handles a user tap by starting or restarting the game when in `idle` or `gameOver`, or applying the jump impulse when `playing`.
    func handleTap() {
        switch state {
        case .idle, .gameOver:
            restart()
        case .playing:
            velocity = jumpStrength
        }
    }

    // MARK: - Core Game Loop
    /// Advances the game simulation by one frame when the engine is in the playing state.
    /// 
    /// Integrates vertical physics for the bird (applies gravity, clamps fall speed, and updates position), checks for floor collision and ends the game when crossed, advances background parallax, and processes each pipe: moves it left, awards a score and light haptic when the bird passes, performs an approximate hitbox collision check (ending the game on collision), and recycles pipes that moved off-screen by repositioning them and randomizing their gap top. This method does nothing unless the game state is `.playing`.
    func update() {
        guard state == .playing else { return }

        // Physics integration
        velocity += gravity
        if velocity > maxFallSpeed {
            velocity = maxFallSpeed
        }
        birdY += velocity

        // Floor collision
        if birdY > floorLimit {
            endGame()
            return
        }

        // Background parallax loop
        bgOffset -= bgSpeed
        if bgOffset <= -loopWidth {
            bgOffset += loopWidth
        }

        // Pipe updates, scoring, and collision
        for i in pipes.indices {
            pipes[i].xPos -= pipeSpeed

            if !pipes[i].isScored && pipes[i].xPos < 0 {
                pipes[i].isScored = true
                score += 1
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }

            // Approximate 30x30 birdY & 48 birdX hitbox check 
            if abs(pipes[i].xPos) < 48 {
                let birdTop = birdY - 20
                let birdBottom = birdY + 20

                if birdTop < pipes[i].gapTop || birdBottom > (pipes[i].gapTop + pipeGapHeight) {
                    endGame()
                    return
                }
            }

            // Pipe recycling for endless scroll
            if pipes[i].xPos < -300 {
                pipes[i].xPos = 500
                pipes[i].gapTop = CGFloat.random(in: -150...50)
                pipes[i].isScored = false
            }
        }
    }

    // MARK: - Game Lifecycle

    /// Reset the game session to its initial playing state.
    /// 
    /// Resets the bird position and motion (`birdY`, `velocity`), clears the current score and background offset, reinitializes the active pipes to the starting positions, and sets the game `state` to `.playing`.
    private func restart() {
        birdY = 0
        velocity = 0
        score = 0
        bgOffset = 0

        pipes = [
            Pipe(xPos: 500, gapTop: 0),
            Pipe(xPos: 850, gapTop: -60)
        ]

        state = .playing
    }

    /// Ends the current game session by transitioning to the game-over state and handling end-of-game side effects.
    /// 
    /// If the current score exceeds the stored high score, updates `highScore` and persists it in `UserDefaults` under the key `"flappy_high_score"`. Also emits an error-style haptic notification.
    private func endGame() {
        state = .gameOver

        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "flappy_high_score")
        }

        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
