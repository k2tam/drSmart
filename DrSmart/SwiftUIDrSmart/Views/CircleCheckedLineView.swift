//
//  DetectedAndCompletedLineView.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 18/01/2024.
//

import SwiftUI

struct CircleCheckedLineView: View {
    let text: String
    let subText: String?
    
    init(text: String, subText: String? = nil) {
        self.text = text
        self.subText = subText
    }
    
    
    var body: some View {
        HStack {
            HiImage(string: "ic_drSmart_tick_circle")
                .frame(width: 36, height: 36)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                
                if let subText {
                    Text(subText)
                        .font(.system(size: 16))
                        .foregroundColor(Color.hiSecondaryText)
                }
                
            }
            
            
            Spacer()
           
        }
        .padding(.all, 16)
        .background(Color.white)
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CircleCheckedLineView(text: "Thông số đường truyền ", subText: "Tốt")
}
