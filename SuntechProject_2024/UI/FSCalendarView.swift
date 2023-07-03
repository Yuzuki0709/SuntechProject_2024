//
//  FSCalendarView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import UIKit
import FSCalendar

class FSCalendarView: UIView {
    
    private var fsCalendar: FSCalendar = {
        let fsCalendar = FSCalendar()
        
        fsCalendar.locale = Locale(identifier: "ja")
        fsCalendar.scope = .week
        
        fsCalendar.appearance.titleWeekendColor = .clear
        fsCalendar.appearance.todayColor = .mainColor
        fsCalendar.appearance.selectionColor = .clear
        fsCalendar.allowsSelection = false
        
        // 土曜日と日曜日を非表示
        fsCalendar.calendarWeekdayView.weekdayLabels[0].isHidden = true
        fsCalendar.calendarWeekdayView.weekdayLabels[6].isHidden = true
        
        return fsCalendar
    }()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
