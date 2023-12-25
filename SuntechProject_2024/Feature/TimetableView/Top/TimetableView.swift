//
//  TimetableView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import SwiftUI

struct TimetableView: View {
    @ObservedObject var viewModel: TimetableViewModel
    
    init(viewModel: TimetableViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                FSCalendarViewRepresentable(
                    bounds: geometry.frame(in: .local),
                    today: $viewModel.today,
                    monday: $viewModel.monday,
                    friday: $viewModel.friday,
                    month: $viewModel.month
                )
                .frame(height: 100)
                
                if let vacation = viewModel.vacation {
                    Spacer()
                    VacationView(name: vacation.name)
                    Spacer()
                } else if let timetableInWeek = viewModel.timetableInWeek {
                    weekTimetableRow(weekTimetable: timetableInWeek)
                        .padding()
                        .loading(viewModel.isLoading)
                    Spacer()
                }
            }
        }
        .backgroundColor(color: Color(R.color.common.backgroundColor))
        .navigationBarBackButtonHidden(true)
        .navigationTitle("時間割")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.navigate(.campusNet)
                } label: {
                    Image(systemName: "doc.text")
                }
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
        .background {
            if classData.isRequired {
                Color(R.color.common.mainColor)
            } else {
                Color(R.color.timetable.electiveSubject)
            }
        }
        .overlay(alignment: .bottom) {
            if viewModel.cancellClassesInWeek.contains(where: { $0.classId == classData.id }) {
                cancellClassText
                    .padding(.bottom, .app.space.spacingXXS)
            }
        }
        .onTapGesture {
            let changeClass = viewModel.changeClassesInWeek.filter({ $0.classId == classData.id }).first
            viewModel.navigate(.classDetail(classData, changeClass))
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
    
    private var cancellClassText: some View {
        RoundedRectangle(cornerRadius: .app.corner.radiusS)
            .fill(.white)
            .foregroundColor(.red)
            .frame(width: 60, height: 15)
            .overlay {
                RoundedRectangle(cornerRadius: .app.corner.radiusS)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.red)
            }
            .overlay {
                HStack(spacing: .app.space.spacingXXS) {
                    Image(systemName: "exclamationmark.octagon")
                    Text("休講")
                }
                .font(.caption)
                .foregroundColor(.red)
            }
    }
}

struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView(viewModel: TimetableViewModel())
    }
}
