//
//  DateHeader.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/14.
//

import SwiftUI

struct DateHeader: View {
    let title: String
    var body: some View {
        HStack(spacing: .app.space.spacingXS) {
            Color(R.color.common.subColor)
                .frame(height: 2)
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.orange)
            Color(R.color.common.subColor)
                .frame(height: 2)
        }
    }
}

struct DateHeader_Previews: PreviewProvider {
    static var previews: some View {
        DateHeader(title: "12月31日")
    }
}
