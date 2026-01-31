//
//  GameOverView.swift
//  Monorepo
//
//  Created by codeAlligator on 31/01/26.
//

import SwiftUI

struct GameOverView: View {
    let state: GameState
    @State private var isVisible = true
    
    var body: some View {
        VStack(spacing: 16) {
            if state == .gameOver {
                Text("GAME OVER")
                    .font(.bungeeSpiceTitle)
                    .opacity(isVisible ? 1 : 0)
            }
            
            Text(state == .idle ? "TAP TO START" : "TAP TO RESTART")
                .font(.bungeeHeadline)
                .foregroundStyle(state == .idle ? .gray : .secondary)
                .opacity(state == .idle ? (isVisible ? 1 : 0.3) : 1)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { _ in
                isVisible.toggle()
            }
        }
    }
}
