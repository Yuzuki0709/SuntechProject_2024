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
}

struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView()
    }
}
