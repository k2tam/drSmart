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

    
    init() {
        self.addIsCheckingCompletedSubscriber()
        self.addRecommendSubscriber()
        self.addProgressSubscriber()
    }
    
    //MARK: - Public Methods
    func runChecking(duration: Int) {
        self.stopChecking()
        self.removeStopCheckingInMiddle()
        self.processTimer =  Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        addProcessTimerSubscriber(duration: duration)
        
    }
    
    //▶️ Play Checking
    func runCheckingTo(percentage: Float, duration: Int){
        self.removeStopCheckingInMiddle()
        runChecking(duration: duration)
        self.percentageStopCheckingInMiddle = percentage
    }
    
    //⏹️ Stop checking
    func stopChecking() {
        processTimerSubscription.forEach { $0.cancel() }
    }
    
    //⏪ Reset checking
    func resetChecking() {
        self.removeStopCheckingInMiddle()
        self.progress = 0
    }
    
    //❌ Cancel checking
    func cancelChecking() {
        self.removeStopCheckingInMiddle()
        stopChecking()
        resetChecking()
    }
    
    

    private func addIsCheckingCompletedSubscriber() {
        $isCheckingCompleted
            .sink {[weak self]  returnedIsCheckingCompleted in
                guard let self else {return}
                    if returnedIsCheckingCompleted {
                        //Available content
                        self.detectedAndSolvedArr = SampleData.sampleDetectedAndSolvedArr
                        self.recommendsForHandlingArr = SampleData.sampleRecommendsForHandlingArr
                        self.notDetectErroArr = SampleData.sampleNotDetectErroItem
                        self.recommend = SampleData.sampleRecommend
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

    
    
    
    private func removeStopCheckingInMiddle() {
        self.percentageStopCheckingInMiddle = nil
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
                        self.removeStopCheckingInMiddle()
                    }
                }
                else {
                    self.isCheckingCompleted = false
                }
            }
            .store(in: &cancelables)
    }
    
  
}




//MARK: - Recommend Tip Handling
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
