//
//  DrSmartProcessItem.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 17/01/2024.
//

import SwiftUI
import SwiftUIBackports

struct DrSmartProcessItem: View {
    var isActive: Bool = false
    var isLoading: Bool = false
    var activeImg: String
    var inActiveImg: String?
    
    init(isActive: Bool, isLoading: Bool = false,activeImg: String, inActiveImg: String? = nil) {
        self.isActive = isActive
        self.isLoading = isLoading
        self.activeImg = activeImg
        self.inActiveImg = inActiveImg
    }
    
    var body: some View {
        ZStack {
            if isLoading {
                LottieView(name: "Scan_Small", loopMode: .loop)
                    .frame(width: 78, height: 78)
               
            }else {
                Circle()
                    .frame(width: 64, height: 64)
                    .foregroundColor(Color(hex: "#E5EAFF",alpha: 0.3))
            }
           
            
            HiImage(string: isActive ? activeImg : inActiveImg ?? "")
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.15), radius: 2.47133, x: 0, y: 0)
                        .backport.overlay(alignment: .topTrailing) {
                            if isActive {
                                HiImage(string: "ic_check")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 13, height: 13)
                                    .offset(y: 1)
                            }
                        }
                    
                )
        }
        
           
            
    }
}

struct DrSmartProcessItem_Previews: PreviewProvider {
    static var previews: some View {
        DrSmartProcessItem(isActive: true, isLoading: true,activeImg: "ic_linear_global", inActiveImg: "ic_linear_disable_global")
            .previewLayout(.sizeThatFits)
    }
}


