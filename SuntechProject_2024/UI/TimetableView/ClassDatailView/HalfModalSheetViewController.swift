//
//  HalfModalSheetViewController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/10.
//

import SwiftUI

struct HalfModalSheetViewController<Sheet: View>: UIViewControllerRepresentable {
    var sheet: Sheet
    @Binding var isShow: Bool
    var onClose: () -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isShow {
            let sheetController = CustomHostingController(rootView: sheet)
            sheetController.presentationController!.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        } else {
            uiViewController.dismiss(animated: true) { onClose() }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfModalSheetViewController
        
        init(parent: HalfModalSheetViewController) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.isShow = false
        }
    }
    
    class CustomHostingController<Content: View>: UIHostingController<Content> {
        override func viewDidLoad() {
            super.viewDidLoad()
            if let sheet = self.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
        }
    }
}
