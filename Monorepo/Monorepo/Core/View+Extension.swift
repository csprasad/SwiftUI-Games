//
//  View+Extension.swift
//  Monorepo
//
//  Created by codeAlligator on 03/02/26.
//

import SwiftUI

extension View {
    func border(width: CGFloat = 2, edges: [Edge] = [.top], color: Color = .gray) -> some View {
        overlay(
            EdgeBorder(width: width, edges: edges).foregroundColor(color)
        )
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat { rect.minX }
            var y: CGFloat { rect.minY }
            var w: CGFloat { rect.width }
            var h: CGFloat { rect.height }

            switch edge {
            case .top: path.addRect(CGRect(x: x, y: y, width: w, height: width))
            case .bottom: path.addRect(CGRect(x: x, y: y + h - width, width: w, height: width))
            case .leading: path.addRect(CGRect(x: x, y: y, width: width, height: h))
            case .trailing: path.addRect(CGRect(x: x + w - width, y: y, width: width, height: h))
            }
        }
        return path
    }
}
