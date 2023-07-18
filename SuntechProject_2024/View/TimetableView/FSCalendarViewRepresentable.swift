//
//  FSCalendarViewRepresentable.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import SwiftUI

struct FSCalendarViewRepresentable: UIViewRepresentable {
    let bounds: CGRect
    
    typealias UIViewType = FSCalendarView
    
    func makeUIView(context: Context) -> FSCalendarView {
        return FSCalendarView(bounds: bounds)
    }
    
    func updateUIView(_ uiView: FSCalendarView, context: Context) {
        
    }
}
