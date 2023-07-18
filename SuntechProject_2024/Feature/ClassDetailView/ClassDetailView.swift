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
    var body: some View {
        
        VStack {
            Spacer()
            classDetailInfo()
            Spacer()
            goButtons()
        }
        .padding()
        .sheet(isPresented: $isShowAttendanceSheet) {
            AttendanceStatusView(classData: classData)
        }
        .backgroundColor(color: Color(R.color.timetable.backgroundColor))
        .customNavigationBar(title: "授業詳細", color: Color(R.color.mainColor))
        .navigationBackButton(color: .white) { dismiss() }
    }
    
    private func classDetailInfo() -> some View {
        VStack(alignment: .leading, spacing: .app.space.spacingS) {
            classDetailInfoRow(headerText: "授業名",
                               contentText: classData.name)
            classDetailInfoRow(headerText: "教授",
                               contentText: classData.teacher.name)
            classDetailInfoRow(headerText: "単位数",
                               contentText: "\(classData.creditsCount)")
            classDetailInfoRow(headerText: "期間",
                               contentText: classData.term.rawValue)
            classDetailInfoRow(headerText: "必選",
                               contentText: classData.isRequired ? "必修" : "選択")
        }
    }
    
    private func classDetailInfoRow(headerText: String, contentText: String) -> some View {
        VStack(alignment: .leading, spacing: .app.space.spacingXXS) {
            Text(headerText)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Text(contentText)
                .font(.system(size: 20))
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
