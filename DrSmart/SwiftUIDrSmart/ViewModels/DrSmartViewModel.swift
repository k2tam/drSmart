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
    var processTimer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    
    @Published var percentageStopCheckingInMiddle: Float? = nil
    @Published var progress: Float = 0
    @Published var checkingDuration: Int = 5
    
    
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
        self.addProcessTimerSubscriber(duration: 5)
//        self.addIsStopProgressSubscriber()
        self.addRecommendSubscriber()
        self.addProgressSubscriber()
    }
    
    
    func addIsCheckingCompletedSubscriber() {
        $isCheckingCompleted
            .sink {[weak self]  returnedIsCheckingCompleted in
                guard let self else {return}
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

    
    func runChecking(duration: Int) {
        self.processTimer =  Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        addProcessTimerSubscriber(duration: duration)
        
    }
    
    func runCheckingTo(percentage: Float, duration: Int){
        runChecking(duration: duration)
        self.percentageStopCheckingInMiddle = percentage
    }
    
    func stopChecking() {
        processTimerSubscription.forEach { $0.cancel() }
    }
    
    func resetChecking() {
        self.progress = 0
    }
    
    func cancelChecking() {
        stopChecking()
        resetChecking()
    }
    
    
    private func addProcessTimerSubscriber(duration: Int){
        if let processTimer = self.processTimer {
            let totalUpdateProgress: Int =  Int(Float(duration) / 0.1)
            processTimer.sink { [weak self] _  in
                guard let self else { return }
                if self.progress < 1.0 {
                    self.progress +=  1.0 / Float(totalUpdateProgress)
                }else {
                    //Stop checking process
                    self.stopChecking()
                }
            }
            .store(in: &processTimerSubscription)
        }else {
            return
        }
     
    }
    
    private func addProgressSubscriber() {
        $progress
            .sink { [weak self] returnProgress in
                guard let self else {return}
                if returnProgress >= 1.0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        self.isCheckingCompleted = true
                    }
                }else if self.percentageStopCheckingInMiddle != nil {
                    if returnProgress >= self.percentageStopCheckingInMiddle!  {
                        stopChecking()
                        self.percentageStopCheckingInMiddle = nil
                    }
                }
                else {
                    self.isCheckingCompleted = false
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
