//
//  Triangle.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/07.
//

import SwiftUI

public struct Triangle: Shape {
    public enum Direction {
        case up
        case down
        case left
        case right
    }
    
    let direction: Direction
    
    init(to direction: Direction) {
        self.direction = direction
    }
    
    public func path(in rect: CGRect) -> Path {
        Path { path in
            let base = base(rect)
            path.move(to: apex(rect))
            path.addLine(to: base.0)
            path.addLine(to: base.1)
            path.closeSubpath()
        }
    }
    
    private func apex(_ rect: CGRect) -> CGPoint {
        switch direction {
        case .up:
            return CGPoint(x: rect.midX, y: rect.minY)
        case .down:
            return CGPoint(x: rect.midX, y: rect.maxY)
        case .left:
            return CGPoint(x: rect.minX, y: rect.midY)
        case .right:
            return CGPoint(x: rect.maxX, y: rect.midY)
        }
    }
    
    private func base(_ rect: CGRect) -> (CGPoint, CGPoint) {
        switch direction {
        case .up:
            return (CGPoint(x: rect.minX, y: rect.maxY), CGPoint(x: rect.maxX, y: rect.maxY))
        case .down:
            return (CGPoint(x: rect.maxX, y: rect.minY), CGPoint(x: rect.minX, y: rect.minY))
        case .left:
            return (CGPoint(x: rect.maxX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.maxY))
        case .right:
            return (CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}

struct Triangle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Group {
                Triangle(to: .up)
                Triangle(to: .down)
                Triangle(to: .left)
                Triangle(to: .right)
            }
            .frame(width: 20, height: 20)
        }
    }
}
