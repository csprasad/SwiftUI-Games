//
//  FlappyEngine.swift
//  Monorepo
//
//  Created by codeAlligator on 03/02/26.
//

import SwiftUI

// MARK: - Game Model
/// Represents a single pipe obstacle in the game
struct Pipe: Identifiable {
    let id = UUID()
    var xPos: CGFloat           // Horizontal position
    var gapTop: CGFloat         // Y-position of gap's top edge
    var isScored: Bool = false  // Prevents double-scoring
}

// MARK: - Game Engine
/// Main game logic controller handling physics, collisions, and state management
@Observable @MainActor
final class FlappyEngine {
    
    // MARK: - Game State
    var state: GameState = .idle
    var birdY: CGFloat = 0          // Bird's vertical position (0 = center)
    var velocity: CGFloat = 0       // Current vertical velocity
    var pipes: [Pipe] = []          // Active obstacles on screen
    
    // MARK: - Background Parallax
    var bgOffset: CGFloat = 0               // Current background scroll position
    private let bgSpeed: CGFloat = 0.6      // Slower than pipes for depth effect
    let loopWidth: CGFloat = 400            // Width before seamless loop reset
    
    // MARK: - Scoring System
    var score: Int = 0
    var highScore: Int = UserDefaults.standard.integer(forKey: "flappy_high_score")
    
    // MARK: - Physics Constants
    /// Tuned for smooth, responsive gameplay
    private let gravity: CGFloat = 0.45          // Downward acceleration per frame
    private let jumpStrength: CGFloat = -8.5     // Upward velocity on tap
    private let maxFallSpeed: CGFloat = 10.0     // Terminal velocity cap
    private let pipeSpeed: CGFloat = 4.0         // Horizontal scroll speed
    private let pipeGapHeight: CGFloat = 170.0   // Vertical gap for bird to pass
    
    // MARK: - Collision Boundaries
    /// Dynamic floor limit set by view's geometry (default fallback value)
    var floorLimit: CGFloat = 350
    
    // MARK: - Interaction Handler
    /// Processes tap input based on current game state
    func handleTap() {
        switch state {
        case .idle, .gameOver:
            restart()
        case .playing:
            // Apply upward impulse (flap)
            velocity = jumpStrength
        }
    }
    
    // MARK: - Core Game Loop
    /// Called every frame (60 FPS) to update game state
    func update() {
        guard state == .playing else { return }
        
        // MARK: 1. Physics Update
        // Apply gravity and cap fall speed
        velocity += gravity
        if velocity > maxFallSpeed {
            velocity = maxFallSpeed
        }
        birdY += velocity
        
        // MARK: 2. Floor Collision
        // Check if bird hit the ground
        if birdY > floorLimit {
            endGame()
            return // Stop processing this frame
        }
        
        // MARK: 3. Background Parallax Scrolling
        bgOffset -= bgSpeed
        
        // Seamless loop: reset when first copy exits left
        if bgOffset <= -loopWidth {
            bgOffset += loopWidth
        }
        
        // MARK: 4. Pipe Management
        for i in pipes.indices {
            // Move pipe left
            pipes[i].xPos -= pipeSpeed
            
            // MARK: Scoring Logic
            // Award point when pipe's center passes bird (x = 0)
            if !pipes[i].isScored && pipes[i].xPos < 0 {
                pipes[i].isScored = true
                score += 1
                
                // Haptic feedback for successful pass
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            
            // MARK: Collision Detection
            // Check if bird is horizontally aligned with pipe (~30x30 pixel hitbox)
            if abs(pipes[i].xPos) < 28 {
                // Calculate bird's vertical bounds
                let birdTop = birdY - 15
                let birdBottom = birdY + 15
                
                // Check if bird collides with top or bottom pipe
                if birdTop < pipes[i].gapTop || birdBottom > (pipes[i].gapTop + pipeGapHeight) {
                    endGame()
                    return // Stop processing this frame
                }
            }
            
            // MARK: Pipe Recycling
            // Move off-screen pipes back to the right
            if pipes[i].xPos < -300 {
                pipes[i].xPos = 500 // Respawn position
                pipes[i].gapTop = CGFloat.random(in: -150...50) // Random height
                pipes[i].isScored = false // Reset scoring flag
            }
        }
    }
    
    // MARK: - Game Lifecycle
    
    /// Resets game state and starts new session
    private func restart() {
        // Reset physics
        birdY = 0
        velocity = 0
        score = 0
        bgOffset = 0
        
        // Spawn initial pipe layout
        pipes = [
            Pipe(xPos: 500, gapTop: 0),      // First pipe
            Pipe(xPos: 850, gapTop: -60)     // Second pipe (staggered)
        ]
        
        state = .playing
    }
    
    /// Handles game over sequence
    private func endGame() {
        state = .gameOver
        
        // Update high score if beaten
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "flappy_high_score")
        }
        
        // Heavy haptic feedback for game over
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
