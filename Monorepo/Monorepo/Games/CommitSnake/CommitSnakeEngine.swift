//
//  CommitSnakeEngine.swift
//  Monorepo
//
/// Created by `C S Prasad` on `30/01/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// swiftlint:disable identifier_name
enum Direction {
    case up, down, left, right
}
// swiftlint:enable identifier_name

@Observable @MainActor
final class CommitSnakeEngine {
    let columns = 25
    let rows = 30

    var snakeBody: [Int] = [45, 44, 43]
    var foodPosition: Int = 100
    var currentDirection: Direction = .right
    var state: GameState = .idle

    /// Handles the primary game button tap to advance the game state.
    /// - When `state` is `.idle`, starts the game (`state = .playing`).
    /// - When `state` is `.gameOver`, resets the game and starts playing.
    /// - When `state` is `.playing`, no action is taken.
    func handleButtonTap() {
        switch state {
        case .idle:
            state = .playing
        case .gameOver:
            resetGame()
            state = .playing
        case .playing:
            break
        }
    }

    /// Advance the snake one cell in its current direction and update the game state accordingly.
    /// 
    /// If the game is not in the `.playing` state this method does nothing. The snake's head is moved one cell in `currentDirection`, wrapping around grid edges. If the new head collides with the snake's body, the game transitions to `.gameOver`. If the new head lands on the food, the snake grows and new food is spawned; if that growth fills the entire grid the game transitions to `.gameOver`. If the new head does not land on food, the tail segment is removed to keep the snake's length constant.
    func move() {
        guard state == .playing else { return }

        let head = snakeBody[0]
        var newHead = head

        switch currentDirection {
        case .up:
            newHead = head - columns
            if newHead < 0 { newHead += columns * rows }
        case .down:
            newHead = head + columns
            if newHead >= columns * rows { newHead -= columns * rows }
        case .left:
            newHead = (head % columns == 0) ? head + (columns - 1) : head - 1
        case .right:
            newHead = (head % columns == columns - 1) ? head - (columns - 1) : head + 1
        }

        if snakeBody.contains(newHead) {
            state = .gameOver
            return
        }

        snakeBody.insert(newHead, at: 0)

        if newHead == foodPosition {
            if snakeBody.count == columns * rows {
                state = .gameOver
                return
            }
            spawnFood()
        } else {
            snakeBody.removeLast()
        }
    }

    /// Resets the game state to its initial configuration.
    /// 
    /// Restores the snake to its starting segments, places food at the initial index, and sets the movement direction to `.right`.
    /// - Note: The snake is set to `[45, 44, 43]`, `foodPosition` to `100`, and `currentDirection` to `.right`.
    private func resetGame() {
        snakeBody = [45, 44, 43]
        foodPosition = 100
        currentDirection = .right
    }

    /// Places food at a random unoccupied grid cell.
    /// - Note: Updates `foodPosition` with an index that is not currently occupied by `snakeBody`.
    private func spawnFood() {
        let occupied = Set(snakeBody)
        var candidate: Int
        repeat {
            candidate = Int.random(in: 0..<(columns * rows))
        } while occupied.contains(candidate)
        foodPosition = candidate
    }
}
