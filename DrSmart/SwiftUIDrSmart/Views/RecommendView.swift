//
//  RecommendView.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 18/01/2024.
//

import SwiftUI


struct RecommendView: View {
    @Binding var isShow: Bool
    let type: eRecommendType
    let title: String
    let descText: String
    
    @State var offset: CGSize = .zero
    
    var icon: String {
        switch type {
        case .error:
            return "ic_bold_danger"
        case .info:
            return "ic_info_circle"
        }
    }

 
    var body: some View {
        if -offset.width <= (UIScreen.main.bounds.width / 2.0) {
            HStack(alignment: .top, spacing: 12) {
                HiImage(string: type == .info ? "ic_info_circle" : "ic_bold_danger")
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading,spacing: 4){
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                    
                    DrSmartExtension.boldKeywordsText(originalText: descText, keywords: ["Tiếp tục báo lỗi."])
                        .font(.system(size: 16))
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity)
                
            }
            .foregroundColor(Color.hiPrimaryText)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .background(Color(hex: type == .info ? "#F1FDF6" : "#FFF3F6"))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.15), radius: 8 / 2, x: 0, y: 4)
            .offset(self.offset)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        withAnimation(.spring()) {
                            if value.translation.width < 0 {
                                self.offset = CGSize(width: value.translation.width, height: 0.0)
                            }

                        }
                    })
                    .onEnded({ value in
                        withAnimation(.spring()) {
                            //Return back if offset not enough
                            if -offset.width < (UIScreen.main.bounds.width / 2.0) {
                                offset = .zero
                            }else {
                                self.isShow = false
                            }

                        }
                    })
            )
        }

       
        
    }
}

#Preview {
    RecommendView(isShow: Binding.constant(true), type: .info, title: "Lưu ý", descText: "Nếu chưa thể xử lý theo gợi ý, Quý khách vui lòng nhấn Tiếp tục báo lỗi.")
}
