//
//  UnhandleErrorView.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 18/01/2024.
//

import SwiftUI

struct RecommendForHandlingView: View {
    let type: eRecommendForHandlingType
    let title: String
    
    @State private var isExpandDesc: Bool = false
    let descText: String?
    let btnText: String?
    let btnAction:  () -> Void?
    
    init(type: eRecommendForHandlingType ,title: String, descText: String?, btnText: String?, btnAction: @escaping () -> Void) {
        self.type = type
        self.title = title
        self.descText = descText
        self.btnText = btnText
        self.btnAction = btnAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            switch self.type {
            case .info:
                HStack(alignment: .top,spacing: 12) {
                    HiImage(string: type.recommendIconString())
                        .frame(width: 24, height: 24)
                    
                    Text(title)
                        .font(.system(size: 16))
                        .foregroundColor(Color.hiPrimaryText)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                }
            case .warning:
                HStack(spacing: 16) {
                    HiImage(string: type.recommendIconString())
                        .frame(width: 36, height: 36)
                    
                    Button(action: {
                        withAnimation {
                            self.isExpandDesc.toggle()
                            
                        }
                    }, label: {
                        HStack(spacing: 0) {
                            Text(title)
                                .font(.system(size: 16, weight: .medium))
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

                
            }
            
            if let descText = descText {
                if self.isExpandDesc {
                    Text(descText )
                        .font(.system(size: 16))
                        .foregroundColor(Color.hiSecondaryText)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity)
                }
            }
            
            //MARK: - Btn View
            if self.type == .warning {
                if let btnText = self.btnText {
                    Button(action: {
                        
                    }, label: {
                        
                        HiSecondaryButton(btnText: btnText) {
                            btnAction()
                        }
                        .frame(height: 40)
                    })
                }
                
            }
            
        }
        .padding(.all, 16)
        .background(Color.white)

        .cornerRadius(8)
    }
    
}

#Preview {
//    RecommendForHandlingView(type: .info, title: "Thực hiện các gợi ý sau để cải thiện chất lượng Internet", descText: nil, btnText: nil) {
//    }
    
    RecommendForHandlingView(type: .warning, title: "Modem không sử dụng băng tần 5Ghz, nhiễu sóng Wi-Fi 2.4Ghz trên thiết bị", descText: "Vui lòng cài đặt lịch tắt mở thiết bị thường xuyên ít nhất 7 ngày 1 lần để thiết bị hoạt động ổn định hơn.", btnText: "Đặt lịch khởi động modem") {
    }
}
