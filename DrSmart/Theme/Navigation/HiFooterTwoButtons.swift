//
//  HiFooterTwoButtons.swift
//  DrSmart
//
//  Created by k2 tam on 23/01/2024.
//

import SwiftUI

struct HiBottomConstants {
    static let kHeightFooterOneButton: CGFloat = 96
    static let kHeightFooterTwoButtons: CGFloat = 122
    static let kContentToFooter: CGFloat = 40
}

enum BottomDirection {
    case vertical
    case horizontal
}


struct HiFooterTwoButtons: View {
    let direction: BottomDirection
    private var heightFooter: CGFloat {
        switch direction {
        case .vertical:
            return HiBottomConstants.kHeightFooterOneButton
        case .horizontal:
            return HiBottomConstants.kHeightFooterTwoButtons
        }
    }
    let primaryTitle: String?
    let primaryAction: () -> Void
    let secondaryTitle: String?
    let secondaryAction: () -> Void
    
    init(
        direction: BottomDirection = .horizontal,
        secondaryTitle: String? = nil,
        secondaryAction: @escaping () -> Void = {},
        primaryTitle: String?,
        primaryAction: @escaping () -> Void
    ) {
        self.direction = direction
        self.primaryTitle = primaryTitle
        self.primaryAction = primaryAction
        self.secondaryTitle = secondaryTitle
        self.secondaryAction = secondaryAction
    }

    var body: some View {
        Group {
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
                .padding(16)
                
            }else {
                VStack(spacing: 16){
                    if let primaryTitle {
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
            }
        }
        .padding(.bottom, 16)
        .background(Color.white)
        .overlay(
            Rectangle()
                .inset(by: 0.25)
                .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 0.5)
            
        )
    }
}

#Preview {
    HiFooterTwoButtons(direction: .horizontal, secondaryTitle: "primary", secondaryAction: {
        
    }, primaryTitle: "secondary") {
        
    }
}

extension View {
    func hiFooter(@ViewBuilder _ footerView: () -> HiFooterTwoButtons) -> some View {
        ZStack(alignment: .bottom) {
            self
            ZStack{
                footerView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
