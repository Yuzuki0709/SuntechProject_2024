//
//  ErrorDialog.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/10/02.
//

import SwiftUI

public extension View {
    func errorDialog(
        _ isPresented: Bool,
        message: String?,
        description: String?,
        okButtonTapped: @escaping () -> Void
    ) -> some View {
        self
            .alert(message ?? "", isPresented: .constant(isPresented)) {
                Button("OK") { okButtonTapped() }
            } message: {
                Text(description ?? "")
            }
    }
}
