//
//  ProcessView.swift
//  DrSmart
//
//  Created by k2 tam on 23/01/2024.
//

import SwiftUI

struct ProcessView: View {
    let progress: CGFloat
    let processArr: [Process]
    let isCheckingCompleted: Bool
    

    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                ForEach(Array(processArr.enumerated()) ,id: \.element.id) { index, process in
                    DrSmartProcessItem(status: process.status,activeImg: process.activeIcon, inActiveImg: process.inActiveIcon)
            
                    if index != processArr.count - 1 {
                        Spacer()
                    }
                }
            }
            .frame(height: 64)
            
            
            if !isCheckingCompleted {
                GeometryReader {geo in
                    Capsule()
                        .foregroundColor(Color(hex: "#DDE4FC"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 4)
                        .backport.overlay(alignment: .leading) {
                            Capsule()
                                .foregroundColor(Color.hiPrimary)
                                .frame(height: 4)
                                .frame(width: (geo.size.width * progress))
                            
                        }

                }
                .padding(.horizontal, 8)

                
            }
            
        }
        
    }
}

//#Preview {
//    ProcessView(progress: <#CGFloat#>, processArr: <#[Process]#>, isCheckingCompleted: <#Bool#>)
//}
