//
//  HiPrimaryView.swift
//  SupportCenter
//
//  Created by k2 tam on 14/11/2023.
//

import SwiftUI

enum eButtonType {
    case primary
    case secondary
}

struct HiPrimaryButton: View {
    let btnText: String
    var isActive: Bool = false
    let onPressed: (() -> Void)
    
    var body: some View {

        Button(action: {
            onPressed()
        }, label: {
            ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.hiPrimary)
                    Text(btnText)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                
                
            }
        })

    }
}

struct HiSecondaryButton: View {
    let btnText: String
    var isActive: Bool = false
    let onPressed: (() -> Void)
    
    var body: some View {

        Button(action: {
            onPressed()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.hiBlueContainer)
                Text(btnText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.hiPrimary)
                    .padding(.vertical, 10)

            }
        })

    }
}









