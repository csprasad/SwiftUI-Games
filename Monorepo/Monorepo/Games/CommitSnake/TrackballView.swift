//
//  TrackballView.swift
//  Monorepo
//
/// Created by `C S Prasad` on `30/01/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

struct TrackballView: View {
    let engine: CommitSnakeEngine
    @State private var ballRotation = CGSize.zero
    @State private var feedbackTrigger: Int = 0
    let onFirstMove: () -> Void

    
    var body: some View {
        // Simple "Socket" background
        Circle()
            .fill(Color(white: 0.1))
            .frame(width: 140, height: 140)
            .overlay {
                // The rolling Ball Image
                Image("trackball")
                    .resizable()
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                    // Visual 3D rotation based on drag
                    .rotation3DEffect(.degrees(Double(ballRotation.width / 2)), axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(Double(-ballRotation.height / 2)), axis: (x: 1, y: 0, z: 0))
            }
            .sensoryFeedback(.selection, trigger: feedbackTrigger)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        ballRotation = value.translation
                        updateDirection(from: value.translation)
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            ballRotation = .zero
                        }
                    }
            )
    }
    
    private func updateDirection(from translation: CGSize) {
        guard engine.state == .playing else { return }

        if engine.state == .idle || engine.state == .gameOver {
            onFirstMove()
        }
        
        let oldDirection = engine.currentDirection
        
        let proposed: Direction = abs(translation.width) > abs(translation.height)
            ? (translation.width > 0 ? .right : .left)
            : (translation.height > 0 ? .down : .up)
        
        let opposites: [Direction: Direction] = [.up: .down, .down: .up, .left: .right, .right: .left]
        guard opposites[oldDirection] != proposed else { return }
        
        engine.currentDirection = proposed
        if oldDirection != engine.currentDirection {
            feedbackTrigger += 1
        }
    }
}
