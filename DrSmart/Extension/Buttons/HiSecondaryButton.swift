//
//  HiSecondaryButton.swift
//  HiThemes
//
//  Created by Khoa Võ  on 23/01/2024.
//

import SwiftUI



struct HiSecondaryButton: View {
    var tapEffect: Bool = true
    var text: String
    var isEnable: Bool = false
    var onClick: () -> Void

    let enableColor = Color.hiBlueContainer
    let disableColor = Color.hi767676.opacity(0.5)
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(text)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isEnable ? Color.hiPrimary : Color.white)
                .background(isEnable ? enableColor : disableColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))        

        }
        .disabled(!isEnable)
        .setEffectButtonStyle(tapEffect)

    }
}



