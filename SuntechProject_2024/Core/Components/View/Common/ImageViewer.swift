//
//  ImageViewer.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/22.
//

import UIKit
import SwiftUI
import Kingfisher

public class UIImageURLViewer: UIView {
    private let imageURL: URL
    private let scrollView: UIScrollView = UIScrollView()
    private let imageView: UIImageView = UIImageView()
    
    required init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(frame: .zero)
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        
        addSubview(scrollView)
        
        imageView.kf.setImage(with: imageURL)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        imageView.frame = scrollView.frame
    }
}

extension UIImageURLViewer: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

struct ImageURLViewerRepresentable: UIViewRepresentable {
    let imageURL: URL
    
    func makeUIView(context: Context) -> UIImageURLViewer {
        return UIImageURLViewer(imageURL: imageURL)
    }
    
    func updateUIView(_ uiView: UIImageURLViewer, context: Context) {}
}

struct ImageViewer: View {
    let imageURL: URL
    let isEditButtonHidden: Bool
    let onBackButtonTap: () -> Void
    let onEditButtonTap: () -> Void
    
    var body: some View {
        ZStack {
            Color.black
            ImageURLViewerRepresentable(imageURL: imageURL)
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    onBackButtonTap()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    onEditButtonTap()
                } label: {
                    HStack(spacing: 1) {
                        Image(systemName: "camera")
                        Text("編集")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .padding(5)
                    .overlay {
                        Capsule()
                            .stroke(lineWidth: 1)
                            .foregroundColor(.white)
                    }
                }
                .hidden(isEditButtonHidden)
            }
        }
    }
    
    init(
        imageURL: URL,
        isEditButtonHidden: Bool = true,
        onBackButtonTap: @escaping () -> Void,
        onEditButtonTap: @escaping () -> Void = {}
    ) {
        self.imageURL = imageURL
        self.isEditButtonHidden = isEditButtonHidden
        self.onBackButtonTap = onBackButtonTap
        self.onEditButtonTap = onEditButtonTap
    }
}

private extension View {
    @ViewBuilder
    func hidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self
                .hidden()
        } else {
            self
        }
    }
}
