//
//  DinoEngine.swift
//  Monorepo
//
/// Created by `C S Prasad` on `31/01/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import Observation

// MARK: - Obstacle Model
/// Obstacle group rendered as repeated cactus emojis.
struct Obstacle: Identifiable {
    let id = UUID()
    var xPos: CGFloat
    var count: Int
}

// MARK: - Game Engine
@Observable @MainActor
final class DinoEngine {

    // MARK: - Game State
    var state: GameState = .idle
    var dinoYOffset: CGFloat = 0
    var velocity: CGFloat = 0
    var obstacles: [Obstacle] = []

    // MARK: - Background Parallax
    var bgOffset: CGFloat = 0
    private let bgSpeed: CGFloat = 0.6      // Slower than pipes to create depth
    let loopWidth: CGFloat = 400            // Width before seamless loop reset

    // MARK: - Scoring
    /// Start time used to compute elapsed deciseconds.
    var startTime: ContinuousClock.Instant?
    var deciSeconds: Int = 0
    var highScore: Int = UserDefaults.standard.integer(forKey: "dino_high_score")

    // MARK: - Physics & Tuning
    let dinoXPosition: CGFloat = -150
    private let baseSpeed: Double = -7.0
    private let gravity: CGFloat = 0.8
    private let jumpStrength: CGFloat = -14

    // MARK: - Dino collision stats
    let dinoHalfWidth: CGFloat = 18
    let cactusHalfWidth: CGFloat = 14

    // MARK: - Speed Scaling
    /// Increases difficulty based on real elapsed time.
    var speedMultiplier: Double {
        let actualSeconds = deciSeconds / 10
        return 1.0 + (Double(actualSeconds / 10) * 0.2)
    }

    /// Process a primary game button tap, either starting/restarting the run or making the dino jump.
    /// 
    /// If the game is in `.idle` or `.gameOver`, a new run is started. If the game is `.playing`, the dino performs a jump.
    func handleButtonTap() {
        switch state {
        case .idle, .gameOver:
            restart()
        case .playing:
            jump()
        }
    }

    /// Initiates the dino's jump when it is on the ground.
    /// 
    /// Sets the vertical velocity to the configured jump strength only if the dino's vertical offset indicates it is grounded; has no effect while airborne.
    private func jump() {
        guard dinoYOffset == 0 else { return }
        velocity = jumpStrength
    }

    // MARK: - Core Game Loop
    /// Advances the game simulation from `startTime` to `currentInstant`, updating timers, physics, background scroll, obstacle positions, collision detection, and obstacle recycling.
    /// - Parameters:
    ///   - currentInstant: The current time instant used to compute elapsed game time and drive the fixed-step update.
    func update(currentInstant: ContinuousClock.Instant) {
        guard state == .playing, let start = startTime else { return }

        let duration = start.duration(to: currentInstant)
        let totalSeconds = Double(duration.components.seconds)
        let attoseconds = Double(duration.components.attoseconds)
        let fractionalSeconds = attoseconds / 1_000_000_000_000_000_000.0
        deciSeconds = Int((totalSeconds + fractionalSeconds) * 10)

        // Background parallax loop

        velocity += gravity
        dinoYOffset += velocity
        if dinoYOffset >= 0 {
            dinoYOffset = 0
            velocity = 0
        }

        let currentMoveSpeed = baseSpeed * speedMultiplier
        bgOffset += CGFloat(currentMoveSpeed)

        for i in obstacles.indices {
            obstacles[i].xPos += CGFloat(currentMoveSpeed)

            // Tight collision window around dino X position.
            if abs(obstacles[i].xPos - dinoXPosition) < (dinoHalfWidth + cactusHalfWidth) && dinoYOffset > -35 {
                endGame()
            }

            // Recycle obstacles to maintain endless run.
            if obstacles[i].xPos < -350 {
                let otherIndex = (i == 0) ? 1 : 0
                let otherX = obstacles[otherIndex].xPos

                let minGap: CGFloat = 280.0
                let randomBuffer = CGFloat.random(in: 50...250)
                let dynamicGap = minGap * speedMultiplier

                obstacles[i].xPos = max(otherX, 350) + dynamicGap + randomBuffer
                obstacles[i].count = Int.random(in: 1...3)
            }
        }
    }

    // MARK: - Lifecycle
    /// Ends the current run and transitions the engine to the game-over state.
    /// If the current decisecond score exceeds the stored high score, updates `highScore` and persists it to `UserDefaults` using the key "dino_high_score".
    private func endGame() {
        state = .gameOver
        if deciSeconds > highScore {
            highScore = deciSeconds
            UserDefaults.standard.set(highScore, forKey: "dino_high_score")
        }
    }

    /// Starts a new run by resetting the timer, score, physics, background, and obstacles, and entering the playing state.
    /// 
    /// Resets `startTime` to now; sets `deciSeconds`, `dinoYOffset`, `velocity`, and `bgOffset` to zero; initializes two obstacles at x positions 350 and 650 with counts 1 and 2; and sets `state` to `.playing`.
    private func restart() {
        startTime = .now
        deciSeconds = 0
        dinoYOffset = 0
        velocity = 0
        bgOffset = 0
        obstacles = [
            Obstacle(xPos: 350, count: 1),
            Obstacle(xPos: 650, count: 2)
        ]
        state = .playing
    }
}
