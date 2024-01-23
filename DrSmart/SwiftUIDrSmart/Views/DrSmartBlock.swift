//
//  DrSmartBlock.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 18/01/2024.
//

import SwiftUI

struct DrSmartBlock<Content:View>: View {
    let blockTitle: String
    let content: Content
    
    init(blockTitle: String, @ViewBuilder content: () -> Content) {
        self.blockTitle = blockTitle
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(blockTitle)
                .font(.system(size: 18,weight: .medium))
                .foregroundColor(Color.hiPrimaryText)
                
           content
           
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DrSmartBlock(blockTitle: "Block title", content: {
        Color.blue
    })
        

}
