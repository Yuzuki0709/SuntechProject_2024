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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
