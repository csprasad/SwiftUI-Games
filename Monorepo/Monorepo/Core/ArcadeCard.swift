//
//  ArcadeGameRow.swift
//  Monorepo
//
//  Created by codeAlligator on 01/02/26.
//

import SwiftUI

struct ArcadeCard: View {
    let game: GameRoute

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Game Title with retro glow
            VStack(alignment: .leading, spacing: 12) {
                Text("> \(game.info.title.uppercased())")
                    .font(.bungeeTitle2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange, .red],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .orange.opacity(0.7), radius: 50)
                
                // Subtitle
                Text(game.info.note)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(.primary)
                
                Rectangle()
                    .stroke(
                        LinearGradient(
                            colors: [.yellow, .orange, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 2, dash: [5, 3]) // [dash length, gap length]
                    )
                    .frame(width: 208, height: 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            
            Image(systemName: "play.fill")
                .font(.bungeeSpiceTitle)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange, .red],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .padding(.trailing, 16)
                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.clear.opacity(0.8))
                .overlay(
                    // CRT scan lines with proper masking
                    GeometryReader { geo in
                        VStack(spacing: 3) {
                            ForEach(0..<Int(geo.size.height / 7), id: \.self) { _ in
                                Rectangle()
                                    .fill(.orange.opacity(0.05))
                                    .frame(height: 1)
                            }
                        }
                    }
                    .mask(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 1) // Inset by border width
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.orange.opacity(0.3), lineWidth: 2)
                )
        )
        .opacity(game.info.isAvailable ? 1.0 : 0.4)
    }
}

