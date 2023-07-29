//
//  WebViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/29.
//

import Foundation

final class WebViewModel {
    let url: URL
    let navigateionTitle: String
    
    init(url: URL, navigateionTitle: String) {
        self.url = url
        self.navigateionTitle = navigateionTitle
    }
}
