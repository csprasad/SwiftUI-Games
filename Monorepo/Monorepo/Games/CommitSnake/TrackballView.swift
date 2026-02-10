//
//  TrackballView.swift
//  Monorepo
//
//  Created by codeAlligator on 30/01/26.
//

import SwiftUI

struct TrackballView: View {
    let engine: CommitSnakeEngine
    @State private var ballRotation = CGSize.zero
    @State private var feedbackTrigger: Int = 0
    
    var body: some View {
        // Simple "Socket" background
        Circle()
            .fill(Color(white: 0.1))
            .frame(width: 140, height: 140)
            .overlay {
                // The actual Ball Image
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
        let oldDirection = engine.currentDirection
        
        // Map 2D swipe to 4-way move
        if abs(translation.width) > abs(translation.height) {
            engine.currentDirection = translation.width > 0 ? .right : .left
        } else {
            engine.currentDirection = translation.height > 0 ? .down : .up
        }
        
        if oldDirection != engine.currentDirection {
            feedbackTrigger += 1
        }
    }
}
