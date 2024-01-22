//
//  DrSmartProcessItem.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 17/01/2024.
//

import SwiftUI
import SwiftUIBackports

struct DrSmartProcessItem: View {
    var status: eDrSmartProcessStatus
    var activeImg: String
    var inActiveImg: String?
    
    init(status: eDrSmartProcessStatus = .inActive,activeImg: String, inActiveImg: String? = nil) {
        self.status = status
        self.activeImg = activeImg
        self.inActiveImg = inActiveImg
    }
    
    var body: some View {
        ZStack {
            if status == .loading {
                LottieView(name: "Scan_Small", loopMode: .loop)
                    .frame(width: 78, height: 78)
               
            }else {
                Circle()
                    .frame(width: 64, height: 64)
                    .foregroundColor(Color(hex: "#E5EAFF",alpha: 0.6))
            }
           
            
            HiImage(string: setIconProcess(self.status))
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.15), radius: 2.47133, x: 0, y: 0)
                        .backport.overlay(alignment: .topTrailing) {
                            if status == .active {
                                HiImage(string: "ic_check")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 13, height: 13)
                                    .offset(y: 1)
                            }
                        }
                    
                )
        }
        
           
            
    }
    
    private func setIconProcess(_ status: eDrSmartProcessStatus) -> String {
        switch status {
        case .loading:
            return inActiveImg ?? ""
        case .active:
            return activeImg
        case .inActive:
            return inActiveImg ?? ""
        }
    }
}

struct DrSmartProcessItem_Previews: PreviewProvider {
    static var previews: some View {
        DrSmartProcessItem(status: .active ,activeImg: "ic_linear_global", inActiveImg: "ic_linear_disable_global")
            .previewLayout(.sizeThatFits)
    }
}


