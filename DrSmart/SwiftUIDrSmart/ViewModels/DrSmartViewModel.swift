//
//  DrSmartViewModel.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 17/01/2024.
//

import Foundation
import Combine



class DrSmartViewModel: ObservableObject {
    @Published var isCheckingCompleted: Bool = false
    private var timer: Timer?
    
    let checkDuration: Int =  5

    
    private var cancelables = Set<AnyCancellable>()
    
    @Published var processArr = [
        Process(status: .active,activeIcon: "ic_linear_devices"),
        Process(status: .loading,activeIcon: "ic_linear_router", inActiveIcon: "ic_linear_inActive_router"),
        Process(status: .inActive,activeIcon: "ic_linear_global", inActiveIcon: "ic_linear_inActive_global")
    ]
    
//    @Published var recommend: Recommend? = Recommend(type: .error, title: "Phát hiện lỗi", body: "Hệ thống có thể sẽ mất vài phút để khắc phục")
    @Published var recommend: Recommend? = nil

    
    @Published var detectedAndSolvedArr: [DetectedAndSolved] = []
    @Published var cantHandleErrorArr: [CantHandleError] = []
    @Published var notDetectErroArr: [NotDetectErroItem] = []
    
    private var sampleDetectedAndSolvedArr: [DetectedAndSolved] = [
        DetectedAndSolved(text: "Modem treo, kết nối Wi-Fi chập chờn Modem treo, kết nối Wi-Fi chập chờn"),
        DetectedAndSolved(text: "Kênh sóng 2.4GHz chưa tối ưu")
    ]
    private var sampleCantHandleErrorArr:  [CantHandleError] = [
        CantHandleError(title: "Modem không sử dụng băng tần 5Ghz, nhiễu sóng Wi-Fi 2.4Ghz trên thiết bị", descText: "Vui lòng cài đặt lịch tắt mở thiết bị thường xuyên ít nhất 7 ngày 1 lần để thiết bị hoạt động ổn định hơn.", btnText: "Đặt lịch khởi động modem")
    ]
    private var sampleNotDetectErroItem: [NotDetectErroItem] = [
        NotDetectErroItem(title: "Thông số đường truyền", body: "Tốt"),
        NotDetectErroItem(title: "Kênh sóng Wi-Fi", body: "Đã tối ưu"),
        NotDetectErroItem(title: "Số lượng thiết bị kết nối", body: "5"),

    ]

    
    init() {
        self.addIsCheckingCompletedSubscriber()
    }
    
    
    func addIsCheckingCompletedSubscriber() {
        $isCheckingCompleted
            .sink {[weak self]  returnedIsCheckingCompleted in
                print(returnedIsCheckingCompleted.description)
                guard let self = self else {
                    return
                }
                
                if returnedIsCheckingCompleted {
                    //Available content
                    self.detectedAndSolvedArr = self.sampleDetectedAndSolvedArr
                    self.cantHandleErrorArr = self.sampleCantHandleErrorArr
                    self.notDetectErroArr = self.sampleNotDetectErroItem
                }else {
                    //Resent content
                    self.detectedAndSolvedArr = []
                    self.cantHandleErrorArr = []
                    self.notDetectErroArr = []
                }
               
            }
            .store(in: &cancelables)
    }
    
   
}
