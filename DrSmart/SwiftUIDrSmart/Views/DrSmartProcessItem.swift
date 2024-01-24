//
//  DrSmartProcessItem.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 17/01/2024.
//

import SwiftUI
import SwiftUIBackports

struct DrSmartProcessItem: View {
    var status: eDrSmartProcessItemStatus
    var activeImg: String
    var inActiveImg: String?
    
    init(status: eDrSmartProcessItemStatus = .inActive,activeImg: String, inActiveImg: String? = nil) {
        self.status = status
        self.activeImg = activeImg
        self.inActiveImg = inActiveImg
    }
    
    var body: some View {
        ZStack {
            if status == .waiting {
                LottieView(name: "Scan_Small", loopMode: .loop)
                    .frame(width: 64, height: 64)
               
            }else {
                Circle()
                    .frame(width: 64, height: 64)
                    .foregroundColor(Color(hex: "#E5EAFF",alpha: 0.3))
            }
           
            
            HiImage(named: setIconProcess(self.status))
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 0)
                        .backport.overlay(alignment: .topTrailing) {
                            if status == .active {
                                HiImage(named: "ic_check")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 13, height: 13)
                                    .offset(y: 1)
                                    
                            }
                        }
                    
                )
        }
        
           
            
    }
    
    private func setIconProcess(_ status: eDrSmartProcessItemStatus) -> String {
        switch status {
        case .waiting:
            return inActiveImg ?? ""
        case .active:
            return activeImg
        case .inActive:
            return inActiveImg ?? ""
        case .loading:
            return activeImg 
        }
    }
}

struct DrSmartProcessItem_Previews: PreviewProvider {
    static var previews: some View {
        DrSmartProcessItem(status: .waiting ,activeImg: "ic_linear_global", inActiveImg: "ic_linear_disable_global")
            .previewLayout(.sizeThatFits)
    }
}


