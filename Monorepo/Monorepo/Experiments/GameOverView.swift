//
//  GameOverView.swift
//  Monorepo
//
//  Created by codeAlligator on 31/01/26.
//

import SwiftUI
internal import Combine

/// Overlay shown for idle and game-over states with blinking prompt.
struct GameOverView: View {
    let state: GameState
    @State private var isVisible = true
    
    var body: some View {
        VStack(spacing: 6) {
            if state == .gameOver {
                Text("GAME OVER")
                    .font(.retroGameLargeTitle)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange, .red],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(isVisible ? 1 : 0)
            }
            
            Text(state == .idle ? "TAP TO START" : "TAP TO RESTART")
                .font(.retroGameHeadline)
                .foregroundStyle(.primary.opacity(0.6))
                .opacity(state == .idle ? (isVisible ? 1 : 0.3) : 1)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { _ in
                isVisible.toggle()
            }
        }
        .padding()
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 24))
    }
}


#Preview {
    GameOverView(state: .gameOver)
}
