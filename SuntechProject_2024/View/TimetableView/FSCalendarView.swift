//
//  FSCalendarView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import UIKit
import SwiftUI
import FSCalendar

class FSCalendarView: UIView {
    
    private var fsCalendar: FSCalendar = {
        let fsCalendar = FSCalendar()
        
        fsCalendar.locale = Locale(identifier: "ja")
        fsCalendar.scope = .week
        
        fsCalendar.appearance.titleWeekendColor = .clear
        fsCalendar.appearance.todayColor = .mainColor
        fsCalendar.appearance.selectionColor = .clear
        fsCalendar.appearance.headerTitleColor = UIColor(Color(R.color.timetable.calendarTextColor))
        fsCalendar.appearance.weekdayTextColor = UIColor(Color(R.color.timetable.calendarTextColor))
        fsCalendar.allowsSelection = false
        
        // 土曜日と日曜日を非表示
        fsCalendar.calendarWeekdayView.weekdayLabels[0].isHidden = true
        fsCalendar.calendarWeekdayView.weekdayLabels[6].isHidden = true
        
        return fsCalendar
    }()
    
    init(bounds: CGRect) {
        super.init(frame: .zero)
        
        fsCalendar.frame = CGRect(x: bounds.minX - ((bounds.width * 1.3 - bounds.width) / 2),
                                  y: bounds.minY,
                                  width: bounds.width * 1.3,
                                  height: 300)
        
        addSubview(fsCalendar)
        
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        
        NSLayoutConstraint.activate([
            fsCalendar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            fsCalendar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            fsCalendar.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            fsCalendar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FSCalendarView: FSCalendarDelegate, FSCalendarDataSource {
    
}
