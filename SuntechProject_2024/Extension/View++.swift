//
//  View++.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/10.
//

import SwiftUI

extension View {
    func halfModal<Sheet: View>(
        isShow: Binding<Bool>,
        @ViewBuilder sheet: @escaping () -> Sheet,
        onClose: @escaping () -> ()
    ) -> some View {
        return self
            .background(
                HalfModalSheetViewController(sheet: sheet(), isShow: isShow, onClose: onClose)
            )
    }
}
