//
//  DrSmartViewModel.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 17/01/2024.
//

import Foundation
import Combine

enum eDrSmartState {
    case runningCheck
    case resultWithoutError
    case resultWithErrorHandledWithoutRecommend
    case resultNoErrorWithRecommends
}

class DrSmartViewModel: ObservableObject {

    @Published var isCheckingCompleted: Bool = false
    @Published var currentState: eDrSmartState = .runningCheck
    var cancelables = Set<AnyCancellable>()
    
    //Progress Props
    private var processTimerSubscription = Set<AnyCancellable>()
    let processTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @Published var isStopProgress: Bool = true
    @Published var percentateStopProgress: Float = 1.0
    @Published var progress: Float = 0
    @Published var checkDuration: Int = 0
    
    
    //Recommend Tip Props
    @Published var recommendTipTimeExist: Int = 5
    private var recommendTipTimerSubscription = Set<AnyCancellable>()
    var recommendTipTimer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    
    
    
    //Data Props
    @Published var processArr = [
        Process(status: .inActive,activeIcon: "ic_linear_devices"),
        Process(status: .inActive,activeIcon: "ic_linear_router", inActiveIcon: "ic_linear_inActive_router"),
        Process(status: .inActive,activeIcon: "ic_linear_global", inActiveIcon: "ic_linear_inActive_global")
    ]
    
    @Published var recommend: Recommend? = nil
    @Published var detectedAndSolvedArr: [DetectedAndSolved] = []
    @Published var recommendsForHandlingArr: [RecommendForHandling] = []
    @Published var notDetectErroArr: [NotDetectErroItem] = []
    
    private let sampleRecommend: Recommend = Recommend(type: .info, title: "Vui lòng kiểm tra lại tình trạng", body: "Nếu lỗi vẫn chưa được khắc phục, hãy nhấn Tiếp tục báo lỗi.", keywords: ["Tiếp tục báo lỗi."])
    
    private let sampleDetectedAndSolvedArr: [DetectedAndSolved] = [
        DetectedAndSolved(text: "Modem treo, kết nối Wi-Fi chập chờn Modem treo, kết nối Wi-Fi chập chờn"),
        DetectedAndSolved(text: "Kênh sóng 2.4GHz chưa tối ưu")
    ]
    
    private let sampleRecommendsForHandlingArr: [RecommendForHandling] = [
        
        RecommendForHandling(type: .info, title: "Thực hiện các gợi ý sau để cải thiện chất lượng Internet", descText: nil, btnText: nil, actionModel: nil),
        
        RecommendForHandling(type: .warning, title: "Modem không sử dụng băng tần 5Ghz, nhiễu sóng Wi-Fi 2.4Ghz trên thiết bị", descText: "Vui lòng cài đặt lịch tắt mở thiết bị thường xuyên ít nhất 7 ngày 1 lần để thiết bị hoạt động ổn định hơn.", btnText: "Đặt lịch khởi động modem",actionModel: ActionModel(actionName: "Đặt lịch khởi động modem")),
        
        RecommendForHandling(type: .warning, title: "Lưu lượnng sử dụng đường truyền ở mức cao", descText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras blandit nisi at risus pharetra, eu eleifend massa blandit.", btnText: "Nâng cấp gói dịch vụ", actionModel: ActionModel(actionName: "Nâng cấp gói dv")),
       
    ]

    private let sampleNotDetectErroItem: [NotDetectErroItem] = [
        NotDetectErroItem(title: "Thông số đường truyền", body: "Tốt"),
        NotDetectErroItem(title: "Kênh sóng Wi-Fi", body: "Đã tối ưu"),
        NotDetectErroItem(title: "Số lượng thiết bị kết nối", body: "5"),

    ]

    
    init() {
        self.addIsCheckingCompletedSubscriber()
        self.addProcessTimerSubscriber()
        self.addIsStopProgressSubscriber()
        self.addRecommendSubscriber()
    }
    
    
    func addIsCheckingCompletedSubscriber() {
        $isCheckingCompleted
            .sink {[weak self]  returnedIsCheckingCompleted in
                guard let self = self else {
                    return
                }
                    if returnedIsCheckingCompleted {
                        //Available content
                        self.detectedAndSolvedArr = self.sampleDetectedAndSolvedArr
                        self.recommendsForHandlingArr = self.sampleRecommendsForHandlingArr
                        self.notDetectErroArr = self.sampleNotDetectErroItem
                        self.recommend = self.sampleRecommend
                    }else {
                        //Reset content
                        self.detectedAndSolvedArr = []
                        self.recommendsForHandlingArr = []
                        self.notDetectErroArr = []
                        self.recommend = nil
                    }
              
               
               
            }
            .store(in: &cancelables)
    }
    
   
    
   
    private func addProcessTimerSubscriber(){
        processTimer.sink { value  in
            if !self.isStopProgress  {
                
                let totalUpdates: Int = Int(Double(self.checkDuration) / 0.1)
                if self.progress < 1.0 {
                    
                    if self.progress >= self.percentateStopProgress {
                        self.stopProgress()
                    }else{
                        self.progress += 1.0 / Float(totalUpdates)
                        
                    }
  
                }else {
                    self.stopProgress()
                }

            }
        }
        .store(in: &processTimerSubscription)
    }
    
    func resetProgress() {
        self.isCheckingCompleted = false
        self.progress = 0
        self.isStopProgress = true
        self.percentateStopProgress = 1.0
        self.checkDuration = 0
        self.currentState = .runningCheck
        
        for i in 0..<self.processArr.count {
            if i == 0 {
                self.processArr[0].status = .loading

            }else {
                self.processArr[i].status = .inActive

            }
            
        }
    }
    
    func stopProgress() {
        self.isStopProgress = true
     
    }
    
    func runProcessWithDuration(duration: Int){
        
        self.isStopProgress = false
        self.checkDuration = duration
        

    }
    
    func killProcessTimer(){
        self.processTimerSubscription.forEach { cancelable in
            cancelable.cancel()
        }
    }
    
    func addIsStopProgressSubscriber() {
        $isStopProgress
            .sink { [weak self]  returnedIsStopProgress in
                guard let self else {return}
                if returnedIsStopProgress {
                    if self.progress >= 1.0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            
                            self.isCheckingCompleted = true
                        }

                    }else if self.progress >= self.percentateStopProgress {
                        self.percentateStopProgress = 1.0

                    }
                }else {
                    
                }
            }
            .store(in: &cancelables)
        
    }
}



//MARK: - Recommend Tip Handler
extension DrSmartViewModel {
    func addRecommendSubscriber() {
        $recommend
            .sink { [weak self] returnedRecommend in
                guard let self else {return}
                
                if let returnedRecommend =  returnedRecommend {
                    self.recommendTipTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
                    self.addRecommendTipTimerSubscriber()
                }else {
                    return
                }

            }
            .store(in: &cancelables)
    }
    
    
    
    func addRecommendTipTimerSubscriber() {
        var tempRecommendTipTimeExist = self.recommendTipTimeExist

        if let recommendTipTimer = recommendTipTimer {
            recommendTipTimer.sink { value in
                if tempRecommendTipTimeExist < 1 {
                    
                    self.recommend = nil
                    self.recommendTipTimerSubscription.forEach {  $0.cancel()}
                    
                
                }else {
                    tempRecommendTipTimeExist -= 1

                }
            }
            .store(in: &recommendTipTimerSubscription)
        }
    }
    
  
    
    func removeRecommendTipBySwipe() {
        self.recommend = nil
        self.recommendTipTimerSubscription.forEach {  $0.cancel()}
    }
}
