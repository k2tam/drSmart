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

struct HiButton: View {
    let type: eButtonType
    let btnText: String
    var isActive: Bool = false
    let onPressed: (() -> Void)
    
    var body: some View {

        Button(action: {
            onPressed()
        }, label: {
            ZStack {
                if(type == .primary){
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.hiPrimary)
                    Text(btnText)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.hiBlueContainer)
                    Text(btnText)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.hiPrimary)
                        .padding(.vertical, 10)
                }
                
            }
        })

    }
}




struct HiButton_Previews: PreviewProvider {
    static var previews: some View {
        HiButton(type: .primary, btnText: "Button") {
            
        }
        .previewLayout(.sizeThatFits)
    }
    
        
   
}



