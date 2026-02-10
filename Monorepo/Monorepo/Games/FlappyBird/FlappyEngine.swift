//
//  FlappyEngine.swift
//  Monorepo
//
//  Created by codeAlligator on 03/02/26.
//

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
    /// Handles tap input depending on game state.
    func handleTap() {
        switch state {
        case .idle, .gameOver:
            restart()
        case .playing:
            velocity = jumpStrength
        }
    }
    
    // MARK: - Core Game Loop
    /// Frame update (~60 FPS).
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
            
            // Approximate 30x30 bird hitbox check
            if abs(pipes[i].xPos) < 28 {
                let birdTop = birdY - 15
                let birdBottom = birdY + 15
                
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
    
    /// Resets game state and starts new session.
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
    
    /// Handles game over state and score persistence.
    private func endGame() {
        state = .gameOver
        
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "flappy_high_score")
        }
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
