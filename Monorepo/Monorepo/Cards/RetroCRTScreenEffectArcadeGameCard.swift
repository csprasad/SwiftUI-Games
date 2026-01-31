//
//  RetroCRTScreenEffectArcadeGameCard.swift
//  Monorepo
//
//  Created by codeAlligator on 31/01/26.
//

import SwiftUI

struct OriginalRetroCRTScreenEffectArcadeGameCard: View {
    let game: GameRoute
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Game Title with retro glow
            Text("> " + game.info.title.uppercased())
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundStyle(.green)
                .shadow(color: .green, radius: 5)
            
            // Subtitle
            Text(game.info.note)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.green.opacity(0.7))
            
            // Pixel separator
            HStack(spacing: 2) {
                ForEach(0..<20) { _ in
                    Rectangle()
                        .fill(.green.opacity(0.3))
                        .frame(width: 8, height: 2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.black.opacity(0.8))
                .overlay(
                    // CRT scan lines
                    GeometryReader { geo in
                        VStack(spacing: 3) {
                            ForEach(0..<Int(geo.size.height / 6), id: \.self) { _ in
                                Rectangle()
                                    .fill(.white.opacity(0.03))
                                    .frame(height: 1)
                            }
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.green.opacity(0.5), lineWidth: 2)
                )
        )
        .opacity(game.info.isAvailable ? 1.0 : 0.4)
    }
}
