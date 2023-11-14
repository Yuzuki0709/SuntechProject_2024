//
//  AttendanceStatusView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/10.
//

import SwiftUI

struct AttendanceStatusView: View {
    @ObservedObject var viewModel: AttendanceStatusViewModel
    
    init(viewModel: AttendanceStatusViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: .app.space.spacingXS) {
            Capsule()
                .fill(Color.secondary)
                .opacity(0.5)
                .frame(width: 80, height: 3)
                .padding(.top, .app.space.spacingXS)
            
            Spacer()
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
        .backgroundColor(color: Color(R.color.common.backgroundColor))
    }
    
    private func countButtons() -> some View {
        HStack(spacing: .app.space.spacingL) {
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
                        .font(.system(size: 15))
                    Spacer()
                    Text(log.status.rawValue)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(.vertical, .app.space.spacingXXS)
                        .padding(.horizontal, .app.space.spacingXS)
                        .background {
                            RoundedRectangle(cornerRadius: .app.corner.radiusS)
                                .fill(log.status.color)
                        }
                }
                .padding(.vertical, .app.space.spacingXXS)
            }
            .onDelete { indexSet in
                guard let index = indexSet.first else { return }
                viewModel.deleteAttendanceLog(log: viewModel.attendanceLogs[index])
            }
        }
        .cornerRadius(.app.corner.radiusS)
        .listStyle(.plain)
    }
    
    private func attendanceButton(status: AttendanceStatus) -> some View {
        Button {
            withAnimation(.default) {
                viewModel.addAttendanceLog(status: status)
                viewModel.isStatusButtonTapped = (true, status)
            }
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
        .disabled(viewModel.isStatusButtonTapped.0)
        .overlay(isPresented: viewModel.isStatusButtonTapped.0) {
            if let tapStatus = viewModel.isStatusButtonTapped.1,
               tapStatus == status {
                LottieView(name: status.onTapAnimationName, loopMode: .playOnce)
                    .frame(width: 100, height: 100)
            }
        }
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
    
    var onTapAnimationName: String {
        switch self {
        case .attendance:
            return "nice"
        case .absence:
            return "sleep"
        case .lateness:
            return "run"
        case .officialAbsence:
            return "mail"
        }
    }
}

struct AttendanceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceStatusView(
            viewModel: AttendanceStatusViewModel(classData: Class(
                id: "23C4110-0238",
                name: "量子コンピューティング",
                teacher: Teacher(
                    id: "F-0004",
                    name: "杉田 勝実",
                    emailAddress: "sugita@suntech.jp"),
                creditsCount: 4,
                timeCount: 60,
                classroomUrl: nil))
        )
    }
}
