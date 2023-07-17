//
//  ActivityIndicator.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/17.
//

import SwiftUI

private struct DisabledView: View {
    var body: some View {
        Color.white.opacity(0.0001)
    }
}

private struct ActivityIndicatorView: UIViewRepresentable {
    var color: UIColor?
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.color = color
        uiView.startAnimating()
    }
}

public struct ActivityIndicator: View {
    public var body: some View {
        ActivityIndicatorView(color: .gray)
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(8)
    }
}

public extension View {
    func loading(_ show: Bool, disabled: Bool = true) -> some View {
        ZStack {
            self
            if show {
                if disabled {
                    DisabledView()
                }
                ActivityIndicator()
            }
        }
    }
}
