//
//  CommitGridView.swift
//  Monorepo
//
//  Created by codeAlligator on 30/01/26.
//

import SwiftUI

struct CommitGridView: View {
    let engine: CommitSnakeEngine
    
    // Grid layout: adaptive squares with 2pt spacing
    private let gridItems = [GridItem(.adaptive(minimum: 12), spacing: 2)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(14), spacing: 2), count: engine.columns), spacing: 2) {
                ForEach(0..<(engine.columns * engine.rows), id: \.self) { index in
                    let snakeSegmentIndex = engine.snakeBody.firstIndex(of: index) ?? -1
                    CommitSquare(isSnake: engine.snakeBody.contains(index), isFood: index == engine.foodPosition, snakeIndex: snakeSegmentIndex)
                }
            }
            .padding()
        }
    }
}

struct CommitSquare: View {
    @Environment(\.colorScheme) var colorScheme
    
    let isSnake: Bool
    let isFood: Bool
    let snakeIndex: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(squareColor)
            .frame(width: 14, height: 14)
    }
    
    private var squareColor: Color {
        if isSnake {
            return snakeColor
        } else if isFood {
            return .pink
        } else {
            // Adaptive gray for the "no-activity" squares
            return colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05)
        }
    }
    
    private var snakeColor: Color {
        if colorScheme == .dark {
            return snakeIndex == 0 ? Color(hex: "#39d353") : Color(hex: "#26a641")
        } else {
            return snakeIndex == 0 ? Color(hex: "#216e39") : Color(hex: "#40c463")
        }
    }
}

// Hex helper for precise GitHub colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(.sRGB, red: Double((int >> 16) & 0xFF) / 255, green: Double((int >> 8) & 0xFF) / 255, blue: Double(int & 0xFF) / 255, opacity: 1)
    }
}
