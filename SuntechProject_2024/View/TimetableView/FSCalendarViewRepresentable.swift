//
//  FSCalendarViewRepresentable.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import SwiftUI
import FSCalendar

struct FSCalendarViewRepresentable: UIViewRepresentable {
    let bounds: CGRect
    @Binding var today: Date
    @Binding var monday: Date
    @Binding var friday: Date
    @Binding var month: Int
    
    typealias UIViewType = FSCalendarView
    
    func makeUIView(context: Context) -> FSCalendarView {
        let fsCalendar = FSCalendarView(bounds: bounds)
        fsCalendar.delegate = context.coordinator
        return fsCalendar
    }
    
    func updateUIView(_ uiView: FSCalendarView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, FSCalendarViewDelegate {
        let parent: FSCalendarViewRepresentable
        
        init(_ parent: FSCalendarViewRepresentable) {
            self.parent = parent
        }
        
        func onAppearCalendar(_ calendar: FSCalendar) {
            Task { @MainActor in
                guard let today = calendar.today else { return }
                parent.today = today
                parent.monday = Calendar.current.date(byAdding: .day, value: 2, to: calendar.currentPage)!
                parent.friday = Calendar.current.date(byAdding: .day, value: 6, to: calendar.currentPage)!
                parent.month = Calendar.current.component(.month, from: calendar.currentPage)
            }
        }
        
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            Task { @MainActor in
                parent.monday = Calendar.current.date(byAdding: .day, value: 2, to: calendar.currentPage)!
                parent.friday = Calendar.current.date(byAdding: .day, value: 6, to: calendar.currentPage)!
                parent.month = Calendar.current.component(.month, from: calendar.currentPage)
            }
        }
    }
}
