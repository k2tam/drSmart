//
//  HiPrimaryButton.swift
//  HiThemes
//
//  Created by Khoa Võ  on 23/01/2024.
//

import SwiftUI

enum eButtonType {
    case primary
    case secondary
}

struct HiPrimaryButton: View {
    var text: String
    var isEnable: Bool = true
    var onClick: () -> Void
    
    let enableColor = Color.hiPrimary
    let disableColor = Color.hiC7CBCF
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(text)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isEnable ? Color.white : Color.black)
                .background(isEnable ? enableColor : disableColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(!isEnable)
    }
}
