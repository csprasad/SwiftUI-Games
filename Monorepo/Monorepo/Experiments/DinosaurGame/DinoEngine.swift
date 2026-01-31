//
//  DinoEngine.swift
//  Monorepo
//
//  Created by codeAlligator on 31/01/26.
//

import SwiftUI
import Observation

// MARK: - Game State
enum GameState {
    case idle, playing, gameOver
}

// MARK: - Obstacles
/// Current version supporting only cactus 🌵
struct Obstacle: Identifiable {
    let id = UUID()
    var xPos: CGFloat
    var count: Int
}

// MARK: - Game Engine
@Observable @MainActor
final class DinoEngine {
    // Game States
    var state: GameState = .idle
    var dinoYOffset: CGFloat = 0
    var velocity: CGFloat = 0
    var obstacles: [Obstacle] = []
    
    // Scoring & High Score (In deciseconds - tenths of a second)
    var startTime: ContinuousClock.Instant?
    var deciSeconds: Int = 0
    var highScore: Int = UserDefaults.standard.integer(forKey: "dino_high_score")
    
    // Constants
    let dinoXPosition: CGFloat = 140
    private let baseSpeed: Double = 7.0
    private let gravity: CGFloat = 0.8
    private let jumpStrength: CGFloat = -14
    
    // Computed Speed (based on actual seconds, not deciseconds)
    var speedMultiplier: Double {
        let actualSeconds = deciSeconds / 10
        return 1.0 + (Double(actualSeconds / 10) * 0.2)
    }
    
    // Button state
    func handleButtonTap() {
        switch state {
        case .idle, .gameOver:
            restart()
        case .playing:
            jump()
        }
    }
    
    // Jumps
    private func jump() {
        guard dinoYOffset == 0 else { return }
        velocity = jumpStrength
    }
    
    // Five steps update to control game
    func update(currentInstant: ContinuousClock.Instant) {
        guard state == .playing, let start = startTime else { return }
        
        //1. Update Timer (in deciSeconds - 10ths of a second)
        let duration = start.duration(to: currentInstant)
        let totalSeconds = Double(duration.components.seconds)
        let attoseconds = Double(duration.components.attoseconds)
        let fractionalSeconds = attoseconds / 1_000_000_000_000_000_000.0
        
        // Convert to deciSeconds (multiply by 10)
        deciSeconds = Int((totalSeconds + fractionalSeconds) * 10)
        
        // 2. Vertical Physics (Gravity)
        velocity += gravity
        dinoYOffset += velocity
        if dinoYOffset >= 0 { dinoYOffset = 0 }
        
        // 3. Horizontal Movement (Left to Right Obstacles)
        let currentMoveSpeed = baseSpeed * speedMultiplier
        
        for i in obstacles.indices {
            obstacles[i].xPos += CGFloat(currentMoveSpeed)
            
            // 4. Collision Detection (Tightened)
            if abs(obstacles[i].xPos - dinoXPosition) < 25 && dinoYOffset > -15 {
                endGame()
            }
            
            // 5. Recycle Obstacle (Off screen right)
            if obstacles[i].xPos > 350 {
                let otherIndex = (i == 0) ? 1 : 0
                let otherX = obstacles[otherIndex].xPos
                
                let minGap: CGFloat = 280.0
                let randomBuffer = CGFloat.random(in: 50...250)
                let dynamicGap = minGap * speedMultiplier
                
                obstacles[i].xPos = min(otherX, -200) - dynamicGap - randomBuffer
                obstacles[i].count = Int.random(in: 1...3)
            }
        }
    }
    
    // Update endgame state & store or update highscore
    private func endGame() {
        state = .gameOver
        if deciSeconds > highScore {
            highScore = deciSeconds
            UserDefaults.standard.set(highScore, forKey: "dino_high_score")
        }
    }
    
    // Restart game
    private func restart() {
        startTime = .now
        deciSeconds = 0
        dinoYOffset = 0
        velocity = 0
        obstacles = [
            Obstacle(xPos: -200, count: 1),
            Obstacle(xPos: -500, count: 2)
        ]
        state = .playing
    }
}
