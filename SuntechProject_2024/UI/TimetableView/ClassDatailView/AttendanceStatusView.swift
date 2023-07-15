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
                    .padding()
                
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
        HStack(spacing: 50) {
            VStack {
                Button {
                    viewModel.addAttendanceLog(status: .attendance)
                } label: {
                    Text("\(viewModel.attendanceCount)")
                }
                .frame(width: 50, height: 50)
                .background(Color(R.color.attendanceStatus.attendance))
                .foregroundColor(.white)
                .clipShape(Circle())
                Text("出席")
                    .foregroundColor(.gray)
            }
            
            VStack {
                Button {
                    viewModel.addAttendanceLog(status: .absence)
                } label: {
                    Text("\(viewModel.absenceCount)")
                }
                .frame(width: 50, height: 50)
                .background(Color(R.color.attendanceStatus.absence))
                .foregroundColor(.white)
                .clipShape(Circle())
                
                Text("欠席")
                    .foregroundColor(.gray)
            }
            
            VStack {
                Button {
                    viewModel.addAttendanceLog(status: .lateness)
                } label: {
                    Text("\(viewModel.latenessCount)")
                }
                .frame(width: 50, height: 50)
                .background(Color(R.color.attendanceStatus.lateness))
                .foregroundColor(.white)
                .clipShape(Circle())
                
                Text("遅刻")
                    .foregroundColor(.gray)
            }
            
        }
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
