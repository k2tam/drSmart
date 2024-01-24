//
//  HiFooterOneButton.swift
//  DrSmart
//
//  Created by k2 tam on 23/01/2024.
//

import SwiftUI

/// Show footer with 1 button, buttonType default is primary if not pass value
/// - Parameters:
///   - buttonType: if not pass any value, DEFAULT WILL BE PRIMARY
///   - title: title
///   - action: action
/// - Returns: View
struct HiFooterOneButton: View {
    let buttonType: eButtonType
    let title: String
    let action: () -> Void
    
    init(buttonType: eButtonType, title: String, action: @escaping () -> Void) {
        self.buttonType = buttonType
        self.title = title
        self.action = action
    }
    
    var body: some View {
        ZStack{
            Color.white
            
            switch buttonType {
            case .primary:
                HiPrimaryButton(text: title) {
                    action()
                }
               
                .padding(.init(top: 16, leading: 16, bottom: 32, trailing: 16))
                .frame(maxWidth: .infinity)
            case .secondary:
                HiSecondaryButton(text: title, isEnable: true) {
                    action()
                }
                .padding(.init(top: 16, leading: 16, bottom: 32, trailing: 16))
                .frame(maxWidth: .infinity)
            }
           
        }
        .frame(height: Constants.kHeightFooter1Button)
    }
}

#Preview {
    HiFooterOneButton(buttonType: .secondary, title: "HI FPT"){
        
    }
}
