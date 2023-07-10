//
//  AttendanceStatusView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/10.
//

import SwiftUI

struct AttendanceStatusView: View {
    let classData: Class
    var body: some View {
        VStack {
            countButtons()
        }
    }
    
    private func countButtons() -> some View {
        HStack(spacing: 50) {
            VStack {
                Button {
                    
                } label: {
                    Text("0")
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
                    
                } label: {
                    Text("0")
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
                    
                } label: {
                    Text("0")
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
