//
//  TimetableView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import SwiftUI

struct TimetableView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                FSCalendarViewRepresentable(bounds: geometry.frame(in: .local))
                    .frame(height: 100)
            }
        }
    }
    
    private func classRow(classData: Class) -> some View {
        VStack(alignment: .leading) {
            Text(classData.name)
                .font(.system(size: 12))
            Text(classData.teacher.name)
                .font(.system(size: 10))
        }
        .frame(height: 90)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color.mainColor)
    }
}

struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView()
    }
}
