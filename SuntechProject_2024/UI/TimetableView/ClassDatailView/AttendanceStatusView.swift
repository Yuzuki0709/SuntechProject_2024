//
//  AttendanceStatusView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/10.
//

import SwiftUI

struct AttendanceStatusView: View {
    var classData: Class
    @StateObject private var viewModel: AttendanceStatusViewModel
    
    init(classData: Class) {
        self.classData = classData
        self._viewModel = StateObject(wrappedValue: AttendanceStatusViewModel(classData: classData))
    }
    
    var body: some View {
        ZStack {
            background()
            VStack(spacing: 20) {
                countButtons()
                attendanceLogList()
            }
            .padding()
            .onAppear {
                // 授業情報が登録されていなかったら、登録する
                if !viewModel.isExistClass() {
                    viewModel.addClassAttendance()
                }
            }
        }
    }
    
    private func background() -> some View {
        Color(R.color.attendanceStatus.backgroundColor)
            .ignoresSafeArea()
    }
    
    private func countButtons() -> some View {
        HStack(spacing: 30) {
            ForEach(AttendanceStatus.allCases, id: \.rawValue) { status in
                VStack {
                    attendanceButton(status: status)
                    Text(status.rawValue)
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                }
            }
        }
        .padding()
    }
    
    private func attendanceLogList() -> some View {
        List {
            ForEach(viewModel.attendanceLogs) { log in
                HStack {
                    Text(DateHelper.formatToString(date: log.date, format: "yyyy-MM-dd"))
                    Spacer()
                    Text(log.status.rawValue)
                }
            }
            .onDelete { indexSet in
                guard let index = indexSet.first else { return }
                viewModel.deleteAttendanceLog(log: viewModel.attendanceLogs[index])
            }
        }
        .listStyle(.plain)
    }
    
    private func attendanceButton(status: AttendanceStatus) -> some View {
        Button {
            viewModel.addAttendanceLog(status: status)
        } label: {
            switch status {
            case .attendance:
                Text("\(viewModel.attendanceCount)")
            case .absence:
                Text("\(viewModel.absenceCount)")
            case .lateness:
                Text("\(viewModel.latenessCount)")
            case .officialAbsence:
                Text("\(viewModel.officialAbsenceCount)")
            }
        }
        .frame(width: 50, height: 50)
        .background(status.color)
        .foregroundColor(.white)
        .clipShape(Circle())
        .contentShape(Circle())
    }
}

private extension AttendanceStatus {
    var color: Color {
        switch self {
        case .attendance:
            return Color(R.color.attendanceStatus.attendance)
        case .absence:
            return Color(R.color.attendanceStatus.absence)
        case .lateness:
            return Color(R.color.attendanceStatus.lateness)
        case .officialAbsence:
            return Color(R.color.attendanceStatus.officialAbsence)
        }
    }
}

struct AttendanceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceStatusView(classData: Class(
            id: "23C4110-0238",
            name: "量子コンピューティング",
            teacher: Teacher(
                id: "F-0004",
                name: "杉田 勝実",
                emailAddress: "sugita@suntech.jp"),
            creditsCount: 4,
            timeCount: 60))
    }
}
