//
//  WebView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/19.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let viewModel: WebViewModel
    
    init(viewModel: WebViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: viewModel.url)
        uiView.load(request)
    }
}
