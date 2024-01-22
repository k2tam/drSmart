//
//  UnhandleErrorView.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 18/01/2024.
//

import SwiftUI

struct UnhandledErrorView: View {
    let title: String
    @State private var isExpandDesc: Bool = false
    let descText: String
    let btnText: String
    let btnAction:  () -> Void
    
    init(title: String, descText: String, btnText: String, btnAction: @escaping () -> Void) {
        self.title = title
        self.descText = descText
        self.btnText = btnText
        self.btnAction = btnAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HiImage(string: "ic_linear_danger")
                    .frame(width: 36, height: 36)
                
                
                Button(action: {
                    withAnimation {
                        self.isExpandDesc.toggle()

                    }
                }, label: {
                    HStack(spacing: 0) {
                        Text(title)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 16)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        HiImage(string: "ic_down_arrow")
                            .rotationEffect(self.isExpandDesc ? .degrees(-180) : .degrees(0))
                            .frame(width: 24, height: 24)
                    }
                    .foregroundColor(.black)
                })
               
                
                
            }
            
            if self.isExpandDesc {
                Text(descText)
                    .font(.system(size: 16))
                    .foregroundColor(Color.hiSecondaryText)
            }
            
            
            Button(action: {
                
            }, label: {
                HiButton(type: .secondary, btnText: "Bật wifi 5Ghz") {
                    btnAction()
                }
                .frame(height: 40)
            })
        }
        .padding(.all, 16)
        .background(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    UnhandledErrorView(title: "Modem không sử dụng băng tần 5Ghz, nhiễu sóng Wi-Fi 2.4Ghz trên thiết bị", descText: "Vui lòng cài đặt lịch tắt mở thiết bị thường xuyên ít nhất 7 ngày 1 lần để thiết bị hoạt động ổn định hơn.", btnText: "Đặt lịch khởi động modem") {
        
    }
}
