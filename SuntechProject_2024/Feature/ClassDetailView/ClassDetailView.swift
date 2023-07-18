//
//  ClassDetailView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/08.
//

import SwiftUI

struct ClassDetailView: View {
    @Environment (\.dismiss) var dismiss
    
    let classData: Class
    @State private var isShowAttendanceSheet: Bool = false
    @StateObject private var viewModel: ClassDetailViewModel
    
    init(classData: Class) {
        self.classData = classData
        self._viewModel = StateObject(wrappedValue: ClassDetailViewModel(classData: classData))
    }
    
    var body: some View {
        VStack(spacing: .app.space.spacingXL) {
            classDetailInfo()
            attendanceStatus()
            goButtons()
        }
        .padding()
        .sheet(isPresented: $isShowAttendanceSheet) {
            AttendanceStatusView(classData: classData)
        }
        .backgroundColor(color: Color(R.color.attendanceStatus.backgroundColor))
        .customNavigationBar(title: "授業詳細", color: Color(R.color.mainColor))
        .navigationBackButton(color: .white) { dismiss() }
    }
    
    private func classDetailInfo() -> some View {
        VStack(alignment: .leading, spacing: .app.space.spacingXS) {
            classDetailInfoRow(headerText: "授業名",
                               headerImage: Image(systemName: "graduationcap"),
                               contentText: classData.name)
            Divider()
            classDetailInfoRow(headerText: "教授",
                               headerImage: Image(systemName: "person"),
                               contentText: classData.teacher.name)
            Divider()
            classDetailInfoRow(headerText: "単位数",
                               headerImage: Image(systemName: "square.3.stack.3d"),
                               contentText: "\(classData.creditsCount)")
            Divider()
            classDetailInfoRow(headerText: "期間",
                               headerImage: Image(systemName: "clock"),
                               contentText: classData.term.rawValue)
            Divider()
            classDetailInfoRow(headerText: "必選",
                               headerImage: Image(systemName: "exclamationmark.triangle"),
                               contentText: classData.isRequired ? "必修" : "選択")
        }
        .padding(.vertical, .app.space.spacingM)
        .padding(.horizontal, .app.space.spacingXXXL)
        .background(Color.white)
        .cornerRadius(.app.corner.radiusM)
    }
    
    private func classDetailInfoRow(headerText: String, headerImage: Image, contentText: String) -> some View {
        VStack(alignment: .leading, spacing: .app.space.spacingXXS) {
            HStack(spacing: .app.space.spacingXS) {
                headerImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 10, height: 10)
                Text(headerText)
                    .font(.system(size: 10))
            }
            .foregroundColor(.gray)
            
            Text(contentText)
                .font(.system(size: 14))
        }
    }
    
    private func attendanceStatus() -> some View {
        VStack(alignment: .leading, spacing: .app.space.spacingXS) {
            HStack {
                Image(systemName: "studentdesk")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 15, height: 15)
                Text("出席状況")
                    .font(.system(size: 15))
            }
            
            HStack(spacing: .app.space.spacingXL) {
                ForEach(AttendanceStatus.allCases, id: \.rawValue) { status in
                    attendanceText(status: status)
                }
            }
        }
        .padding(.vertical, .app.space.spacingM)
        .padding(.horizontal, .app.space.spacingXXXL)
        .background(Color.white)
        .cornerRadius(.app.corner.radiusM)
    }
    
    private func attendanceText(status: AttendanceStatus) -> some View {
        VStack {
            switch status {
            case .attendance:
                Text("\(viewModel.attendanceCount)")
                    .font(.system(size: 40))
                    .foregroundColor(status.color)
            case .absence:
                Text("\(viewModel.absenceCount)")
                    .font(.system(size: 40))
                    .foregroundColor(status.color)
            case .lateness:
                Text("\(viewModel.latenessCount)")
                    .font(.system(size: 40))
                    .foregroundColor(status.color)
            case .officialAbsence:
                Text("\(viewModel.officialAbsenceCount)")
                    .font(.system(size: 40))
                    .foregroundColor(status.color)
            }
            
            Text(status.rawValue.prefix(2))
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
    }
    
    private func goButtons() -> some View {
        VStack(spacing: .app.space.spacingS) {
            button(text: "出席情報を確認") {
                isShowAttendanceSheet = true
            }
            button(text: "Classroomへ") {}
            button(text: "授業評価を見る") {}
        }
    }
    
    private func button(text: String, onTap: @escaping (() -> Void)) -> some View {
        Button {
            onTap()
        } label: {
            Text(text)
        }
        .frame(width: 200, height: 50)
        .foregroundColor(.white)
        .background(Color.mainColor)
        .cornerRadius(.app.corner.radiusM)
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

struct ClassDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ClassDetailView(classData: Class(
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
}
