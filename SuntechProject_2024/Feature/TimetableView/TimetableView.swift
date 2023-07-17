//
//  TimetableView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import SwiftUI

struct TimetableView: View {
    @StateObject private var viewModel = TimetableViewModel()
    var body: some View {
        GeometryReader { geometry in
            VStack {
                FSCalendarViewRepresentable(bounds: geometry.frame(in: .local))
                    .frame(height: 100)
                
                if let weekTimetable = viewModel.weekTimetable {
                    weekTimetableRow(weekTimetable: weekTimetable)
                        .padding()
                        .overlay {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            }
                        }
                }
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchWeekTimetable()
        }
        .backgroundColor(color: Color(R.color.timetable.backgroundColor))
        .navigationBarBackButtonHidden(true)
        .customNavigationBar(title: "時間割", color: Color(R.color.mainColor))
    }
    
    private func classRow(classData: Class) -> some View {
        NavigationLink(destination: ClassDetailView(classData: classData)) {
            VStack(alignment: .leading) {
                Text(classData.name)
                    .font(.system(size: 12))
                Text(classData.teacher.name)
                    .font(.system(size: 10))
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background {
                if classData.isRequired {
                    Color.mainColor
                } else {
                    Color.electiveSubjectColor
                }
            }
        }
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
