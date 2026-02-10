//
//  DinoEngine.swift
//  Monorepo
//
//  Created by codeAlligator on 31/01/26.
//

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
    
    // MARK: - Speed Scaling
    /// Increases difficulty based on real elapsed time.
    var speedMultiplier: Double {
        let actualSeconds = deciSeconds / 10
        return 1.0 + (Double(actualSeconds / 10) * 0.2)
    }
    
    // MARK: - Input
    func handleButtonTap() {
        switch state {
        case .idle, .gameOver:
            restart()
        case .playing:
            jump()
        }
    }
    
    private func jump() {
        guard dinoYOffset == 0 else { return }
        velocity = jumpStrength
    }
    
    // MARK: - Core Game Loop
    /// Fixed-step update driven by view task loop.
    func update(currentInstant: ContinuousClock.Instant) {
        guard state == .playing, let start = startTime else { return }
        
        let duration = start.duration(to: currentInstant)
        let totalSeconds = Double(duration.components.seconds)
        let attoseconds = Double(duration.components.attoseconds)
        let fractionalSeconds = attoseconds / 1_000_000_000_000_000_000.0
        deciSeconds = Int((totalSeconds + fractionalSeconds) * 10)
        
        velocity += gravity
        dinoYOffset += velocity
        if dinoYOffset >= 0 { dinoYOffset = 0 }
        
        let currentMoveSpeed = baseSpeed * speedMultiplier
        
        for i in obstacles.indices {
            obstacles[i].xPos += CGFloat(currentMoveSpeed)
            
            // Tight collision window around dino X position.
            if abs(obstacles[i].xPos - dinoXPosition) < 35 && dinoYOffset > -15 {
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
    /// Ends run and persists high score.
    private func endGame() {
        state = .gameOver
        if deciSeconds > highScore {
            highScore = deciSeconds
            UserDefaults.standard.set(highScore, forKey: "dino_high_score")
        }
    }
    
    /// Resets engine to initial running state.
    private func restart() {
        startTime = .now
        deciSeconds = 0
        dinoYOffset = 0
        velocity = 0
        obstacles = [
            Obstacle(xPos: 350, count: 1),
            Obstacle(xPos: 650, count: 2)
        ]
        state = .playing
    }
}
