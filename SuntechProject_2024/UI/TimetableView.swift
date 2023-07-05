//
//  TimetableView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import SwiftUI

struct TimetableView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                FSCalendarViewRepresentable(bounds: geometry.frame(in: .local))
                    .frame(height: 100)
                
                weekTimetableRow(weekTimetable: sampleWeekTimetable)
                    .padding()
                
                Spacer()
            }
        }
    }
    
    private func classRow(classData: Class) -> some View {
        VStack(alignment: .leading) {
            Text(classData.name)
                .font(.system(size: 12))
            Text(classData.teacher.name)
                .font(.system(size: 10))
        }
        .frame(height: 90)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color.mainColor)
    }
    
    private func dayTimetableRow(dayTimetables: [DayTimetable]) -> some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
            ForEach(1..<5, id: \.self) { num in
                let timetable = dayTimetables
                    .filter { $0.period1 == num || $0.period2 == num }
                    .first
                
                if let timetable = timetable {
                    classRow(classData: timetable.classData)
                } else {
                    Rectangle()
                        .stroke(lineWidth: 1)
                        .foregroundColor(.gray.opacity(0.4))
                        .frame(height: 90)
                }
            }
        }
    }
    
    private func weekTimetableRow(weekTimetable: WeekTimetable) -> some View {
        HStack {
            dayTimetableRow(dayTimetables: weekTimetable.monday)
            dayTimetableRow(dayTimetables: weekTimetable.tuesday)
            dayTimetableRow(dayTimetables: weekTimetable.wednesday)
            dayTimetableRow(dayTimetables: weekTimetable.thursday)
            dayTimetableRow(dayTimetables: weekTimetable.friday)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView()
    }
}