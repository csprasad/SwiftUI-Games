//
//  FlappyEngine.swift
//  Monorepo
//
//  Created by codeAlligator on 03/02/26.
//

import SwiftUI
import Observation

// MARK: - Game Model
struct Pipe: Identifiable {
    let id = UUID()
    var xPos: CGFloat
    var gapTop: CGFloat
    var isScored: Bool = false // Prevents double-scoring and ensures instant updates
}

// MARK: - Game Engine
@Observable @MainActor
final class FlappyEngine {
    // Game States
    var state: GameState = .idle
    var birdY: CGFloat = 0
    var velocity: CGFloat = 0
    var pipes: [Pipe] = []
    var bgOffset: CGFloat = 0
    private let bgSpeed: CGFloat = 0.6 // Slower than pipes
    let loopWidth: CGFloat = 400
    
    // Scoring
    var score: Int = 0
    var highScore: Int = UserDefaults.standard.integer(forKey: "flappy_high_score")
    
    // Physics & Tuning Constants
    private let gravity: CGFloat = 0.45       // Slower, more controllable pull
    private let jumpStrength: CGFloat = -8.5  // Gentle flap
    private let maxFallSpeed: CGFloat = 10.0  // Terminal velocity to prevent "teleporting"
    private let pipeSpeed: CGFloat = 4.0      // Smooth horizontal flow
    private let pipeGapHeight: CGFloat = 170.0 // Difficulty: Gap size between pipes
    
    //TODO: - Update late dynamic Bounds (Set by view onAppear/onGeometryChange)
    var floorLimit: CGFloat = 350

    // MARK: - Interaction
    func handleTap() {
        switch state {
        case .idle, .gameOver:
            restart()
        case .playing:
            velocity = jumpStrength
        }
    }
    
    // MARK: - Core Game Loop
    func update() {
        guard state == .playing else { return }
        
        // 1. Physics Engine
        velocity += gravity
        if velocity > maxFallSpeed { velocity = maxFallSpeed }
        birdY += velocity
        
        // 2. Floor Collision (Dynamic Limit)
        if birdY > floorLimit {
            endGame()
        }
        
        // 3. Pipe Movement & Logic
        for i in pipes.indices {
            // Horizontal scroll
            pipes[i].xPos -= pipeSpeed
            
            // Instant Scoring Logic
            // Trigger when pipe cross the bird's center (X = 0)
            if !pipes[i].isScored && pipes[i].xPos < 0 {
                pipes[i].isScored = true
                score += 1
                // Provide tactile feedback
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            
            // Collision Detection (Hitbox: ~30x30 pixels)
            if abs(pipes[i].xPos) < 28 {
                let birdTop = birdY - 15
                let birdBottom = birdY + 15
                
                // Check if bird is hitting top or bottom pipe
                if birdTop < pipes[i].gapTop || birdBottom > (pipes[i].gapTop + pipeGapHeight) {
                    endGame()
                }
            }
            
            // Update background offset for parallax effect
            bgOffset -= bgSpeed
            
            // Reset to loop (assuming 500 is your screen width)
            if bgOffset <= -loopWidth {
                bgOffset += loopWidth // Jump back by exactly one loop width
            }
            
            // Recycle Pipes (Off-screen left to Right)
            if pipes[i].xPos < -300 {
                pipes[i].xPos = 500
                pipes[i].gapTop = CGFloat.random(in: -150...50)
                pipes[i].isScored = false // Reset for next pass
            }
        }
    }
    
    // MARK: - Lifecycle
    private func restart() {
        birdY = 0
        velocity = 0
        score = 0
        bgOffset = 0
        // Initial spawning positions
        pipes = [
            Pipe(xPos: 500, gapTop: 0),
            Pipe(xPos: 850, gapTop: -60)
        ]
        state = .playing
    }
    
    private func endGame() {
        state = .gameOver
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "flappy_high_score")
        }
        // Heavy haptic for game over
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
