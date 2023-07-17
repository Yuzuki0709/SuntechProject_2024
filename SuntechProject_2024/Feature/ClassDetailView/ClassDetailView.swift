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
        ZStack {
            background()
            
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
        }
        .customNavigationBar(title: "授業詳細", color: Color(R.color.mainColor))
        .navigationBackButton(color: .white) { dismiss() }
    }
    
    private func background() -> some View {
        Color(R.color.timetable.backgroundColor)
            .ignoresSafeArea()
    }
    
    private func classDetailInfo() -> some View {
        VStack(alignment: .leading, spacing: 15) {
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
        VStack(alignment: .leading, spacing: 5) {
            Text(headerText)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Text(contentText)
                .font(.system(size: 20))
        }
    }
    
    private func goButtons() -> some View {
        VStack(spacing: 15) {
            Button {
                isShowAttendanceSheet = true
            } label: {
                Text("出席情報を確認")
            }
            .frame(width: 200, height: 50)
            .foregroundColor(.white)
            .background(Color.mainColor)
            .cornerRadius(20)
            
            Button {
                
            } label: {
                Text("ClassRoomへ")
            }
            .frame(width: 200, height: 50)
            .foregroundColor(.white)
            .background(Color.mainColor)
            .cornerRadius(20)
            
            Button {
                
            } label: {
                Text("授業評価を見る")
            }
            .frame(width: 200, height: 50)
            .foregroundColor(.white)
            .background(Color.mainColor)
            .cornerRadius(20)
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
