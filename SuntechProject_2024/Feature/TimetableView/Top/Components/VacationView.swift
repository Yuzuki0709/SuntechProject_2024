//
//  VacationView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/09/13.
//

import SwiftUI

struct VacationView: View {
    let name: String
    
    var body: some View {
        VStack {
            LottieView(name: "vacation", loopMode: .loop)
                .frame(maxWidth: .infinity, maxHeight: 300)
            Text("今は\(name)中です。")
            Text("ゆっくり休んでね。")
        }
    }
}

struct VacationView_Previews: PreviewProvider {
    static var previews: some View {
        VacationView(name: "夏休み")
    }
}
