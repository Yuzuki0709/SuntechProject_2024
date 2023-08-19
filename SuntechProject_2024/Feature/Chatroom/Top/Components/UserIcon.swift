//
//  UserIcon.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/19.
//

import SwiftUI
import Kingfisher

struct UserIcon: View {
    let iconUrlString: String?
    let size: CGFloat
    var body: some View {
        
        if let iconUrlString = iconUrlString,
           let iconUrl = URL(string: iconUrlString) {
            KFImage(iconUrl)
                .placeholder { _ in ProgressView() }
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        } else {
            Image(systemName: "person")
                .foregroundColor(.white)
                .background {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: size, height: size)
                }
                .padding()
        }
    }
}

struct UserIcon_Previews: PreviewProvider {
    static var previews: some View {
        UserIcon(iconUrlString: "https://proj-r.works/user_icon/user_icon-1692415720153.jpeg", size: 50)
            .previewDisplayName("設定あり")
        UserIcon(iconUrlString: nil, size: 50)
            .previewDisplayName("設定なし")
    }
}
