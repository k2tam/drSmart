//
//  HiFooterTwoButtons.swift
//  DrSmart
//
//  Created by k2 tam on 23/01/2024.
//

import SwiftUI

struct HiFooterTwoButtons: View {
    let direction: eDirection
    private var heightFooter: CGFloat {
        switch direction {
        case .vertical:
            return Constants.kHeightFooter2Buttons
        case .horizontal:
            return Constants.kHeightFooter1Button
        }
    }
    let primaryTitle: String?
    let primaryAction: () -> Void
    let secondaryTitle: String?
    let secondaryAction: () -> Void
    
    init(direction: eDirection, primaryTitle: String?, primaryAction: @escaping () -> Void, secondaryTitle: String?, secondaryAction: @escaping () -> Void) {
        self.direction = direction
        self.primaryTitle = primaryTitle
        self.primaryAction = primaryAction
        self.secondaryTitle = secondaryTitle
        self.secondaryAction = secondaryAction
    }

    var body: some View {
        ZStack{
            Color.white
            
            if direction == .horizontal {
                HStack(spacing: 16){
                    if let secondaryTitle  {
                        HiSecondaryButton(text: secondaryTitle, isEnable: true) {
                            secondaryAction()
                        }
                        .frame(height: 48)
                    }
                    
                    if let primaryTitle {
                        HiPrimaryButton(text: primaryTitle) {
                            primaryAction()
                        }
                        .frame(height: 48)
                    }
                    
                    
                }
                .padding(.init(top: 16, leading: 16, bottom: 32, trailing: 16))
                
            }else {
                VStack(spacing: 16){
                    if let primaryTitle{
                        HiPrimaryButton( text: primaryTitle) {
                            primaryAction()
                        }
                        .frame(height: 48)
                    }
                    
                    if let secondaryTitle {
                        HiSecondaryButton(text: secondaryTitle) {
                            secondaryAction()
                        }
                        .frame(height: 48)
                    }
                    
                    
                }
                .padding(.init(top: 16, leading: 16, bottom: 32, trailing: 16))
            }
        }
        .frame(height: self.heightFooter)
    }
}

#Preview {
    HiFooterTwoButtons(direction: .horizontal, primaryTitle: "primary", primaryAction: {
        
    }, secondaryTitle: "secondary") {
        
    }
}
