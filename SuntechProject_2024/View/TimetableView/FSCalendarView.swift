//
//  FSCalendarView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import UIKit
import SwiftUI
import FSCalendar

public protocol FSCalendarViewDelegate: AnyObject {
    func onAppearCalendar(_ calendar: FSCalendar)
    func calendarCurrentPageDidChange(_ calendar: FSCalendar)
}

final class FSCalendarView: UIView {
    
    weak var delegate: FSCalendarViewDelegate?
    
    private var fsCalendar: FSCalendar = {
        let fsCalendar = FSCalendar()
        
        fsCalendar.locale = Locale(identifier: "ja")
        fsCalendar.scope = .week
        
        fsCalendar.appearance.titleWeekendColor = .clear
        fsCalendar.appearance.todayColor = R.color.common.mainColor()
        fsCalendar.appearance.selectionColor = .clear
        fsCalendar.appearance.titleDefaultColor = UIColor(Color(R.color.timetable.calendarTitleColor))
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
        
//        delegate?.onAppearCalendar(fsCalendar)
    }
    
//    override func didMoveToSuperview() {
//        print(#function)
//        delegate?.onAppearCalendar(fsCalendar)
//    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        delegate?.onAppearCalendar(fsCalendar)
        super.willMove(toSuperview: newSuperview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FSCalendarView: FSCalendarDelegate, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        delegate?.calendarCurrentPageDidChange(calendar)
    }
}
