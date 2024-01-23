//
//  TextsProgressView.swift
//  DrSmart
//
//  Created by k2 tam on 23/01/2024.
//

import SwiftUI

struct TextsProgressView: View {
    let isCheckingCompleted: Bool
    let descText: String
    var body: some View {
        VStack(spacing: 8){
            Text(self.isCheckingCompleted ? "Hoàn tất" : "Đang kiểm tra..." )
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.hiPrimaryText)
            
            if !self.isCheckingCompleted {
                Text(self.descText)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    .foregroundColor(Color.hiSecondaryText)
            }
        }
    }
}

#Preview {
    TextsProgressView(isCheckingCompleted: false, descText: "Hệ thống đang kiểm tra lỗi. Vui lòng đợi trong giây lát.")
}
