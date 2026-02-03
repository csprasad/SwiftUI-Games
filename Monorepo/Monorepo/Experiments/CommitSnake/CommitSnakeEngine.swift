//
//  CommitSnakeEngine.swift
//  Monorepo
//
//  Created by codeAlligator on 30/01/26.
//

import SwiftUI

enum Direction {
    case up, down, left, right
}

@Observable @MainActor
final class CommitSnakeEngine {
    let columns = 25
    let rows = 30
    
    var snakeBody: [Int] = [45, 44, 43]
    var foodPosition: Int = 100
    var currentDirection: Direction = .right
    var isGameOver = false
    
    func move() {
        guard !isGameOver else { return }
        
        // Calculate new head position
        let head = snakeBody[0]
        var newHead = head
        
        switch currentDirection {
            case .up: newHead -= columns
            case .down: newHead += columns
            case .left: newHead -= 1
            case .right: newHead += 1
        }
        
        // Wrap around or Collision logic
        if newHead < 0 || newHead >= (columns * rows) || snakeBody.contains(newHead) {
            // Basic collision for now
            return
        }
        
        snakeBody.insert(newHead, at: 0)
        
        if newHead == foodPosition {
            spawnFood() // Grow the snake
        } else {
            snakeBody.removeLast() // Move forward
        }
    }
    
    private func spawnFood() {
        foodPosition = Int.random(in: 0..<(columns * rows))
    }
}
