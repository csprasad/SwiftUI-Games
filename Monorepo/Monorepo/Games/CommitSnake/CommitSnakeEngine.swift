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

    private func resetGame() {
        snakeBody = [45, 44, 43]
        foodPosition = 100
        currentDirection = .right
    }

    private func spawnFood() {
        let occupied = Set(snakeBody)
        var candidate: Int
        repeat {
            candidate = Int.random(in: 0..<(columns * rows))
        } while occupied.contains(candidate)
        foodPosition = candidate
    }
}
