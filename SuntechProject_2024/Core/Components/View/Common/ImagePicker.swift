//
//  ImagePicker.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    typealias PHPickerViewCompletionHandler = (([PHPickerResult]) -> Void)
    
    var configuration: PHPickerConfiguration = {
        var config = PHPickerConfiguration()
        config.filter = .images
        return config
    }()
    
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let vc = PHPickerViewController(configuration: configuration)
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            let itemProvider  = results.first?.itemProvider
            if let itemProvider = itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let uiImage = image as? UIImage {
                        self.parent.selectedImage = uiImage
                    }
                    if let error = error {
                        print(error)
                    }
                }
            }
            
        }
    }
}
