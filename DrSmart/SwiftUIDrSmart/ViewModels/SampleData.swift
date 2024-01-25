//
//  SampleData.swift
//  DrSmart
//
//  Created by k2 tam on 25/01/2024.
//

import Foundation

struct SampleData {
    static let sampleRecommend: Recommend = Recommend(type: .info, title: "Vui lòng kiểm tra lại tình trạng", body: "Nếu lỗi vẫn chưa được khắc phục, hãy nhấn Tiếp tục báo lỗi.", keywords: ["Tiếp tục báo lỗi."])
    
    static let sampleDetectedAndSolvedArr: [DetectedAndSolved] = [
        DetectedAndSolved(text: "Modem treo, kết nối Wi-Fi chập chờn Modem treo, kết nối Wi-Fi chập chờn"),
        DetectedAndSolved(text: "Kênh sóng 2.4GHz chưa tối ưu")
    ]
    
    static let sampleRecommendsForHandlingArr: [RecommendForHandling] = [
        
        RecommendForHandling(type: .info, title: "Thực hiện các gợi ý sau để cải thiện chất lượng Internet", descText: nil, btnText: nil, actionModel: nil),
        
        RecommendForHandling(type: .warning, title: "Modem không sử dụng băng tần 5Ghz, nhiễu sóng Wi-Fi 2.4Ghz trên thiết bị", descText: "Vui lòng cài đặt lịch tắt mở thiết bị thường xuyên ít nhất 7 ngày 1 lần để thiết bị hoạt động ổn định hơn.", btnText: "Đặt lịch khởi động modem",actionModel: ActionModel(actionName: "Đặt lịch khởi động modem")),
        
        RecommendForHandling(type: .warning, title: "Lưu lượnng sử dụng đường truyền ở mức cao", descText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras blandit nisi at risus pharetra, eu eleifend massa blandit.", btnText: "Nâng cấp gói dịch vụ", actionModel: ActionModel(actionName: "Nâng cấp gói dv")),
       
    ]

    static let sampleNotDetectErroItem: [NotDetectErroItem] = [
        NotDetectErroItem(title: "Thông số đường truyền", body: "Tốt"),
        NotDetectErroItem(title: "Kênh sóng Wi-Fi", body: "Đã tối ưu"),
        NotDetectErroItem(title: "Số lượng thiết bị kết nối", body: "5"),

    ]
}
