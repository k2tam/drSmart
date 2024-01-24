//
//  DrSmartScreen.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 17/01/2024.
//

import SwiftUI
import SwiftUIBackports
import Lottie
import Combine


enum eDrSmartAction {
    case recommendForHandling(ActionModel)
    case footerAction(ActionModel)
    case recommendTip(ActionModel)
}

protocol DrSmartScreenDelegate: AnyObject {
    func drSmartActionTracking(actionType: eDrSmartAction)
}

struct DrSmartScreen: View {
    var delegate: DrSmartScreenDelegate?
    @State var isStopProcess: Bool = false

    
    @State var isCancelCheckProgress: Bool = false
    @State var checkProgressQueue: DispatchQueue? = nil
    @State var checkProgressItem: DispatchWorkItem? = nil
    

    @Backport.StateObject var vm =  DrSmartViewModel()
    @State private var progress: CGFloat = 0.0
    @State private var currentProcessIndex: Int = 0
    
    @State private var timer: Timer?

    
    //Recommend tip view props
    let recommendTipTimer = Timer.publish(every: 1.0, on: .main, in: .common)
    @State var recommendTipTimerCancelables = Set<AnyCancellable>()
    @State private var isShowRecommendTip: Bool = false
    @State private var recommendTipDurationCount: Int = 4
    
    
    //Navigation and footer props
    @State var navTitle: String = "Kiểm tra"
    @State var btnFooterPrimaryTitle: String? = nil
    @State var btnFooterSecondaryTitle: String? = "Huỷ quét"

    
    var body: some View {
        NavigationView {
            HiNavigationView {
                ZStack(alignment: .bottom) {
                    Color.hiBackground
                    contentView
                    recommendTipView
                }
                .hiNavigationTitle(self.navTitle)
                .hiNavButtonHidden(vm.isCheckingCompleted)
                .hiNavBarTrailingView {
                    if vm.isCheckingCompleted {
                        Button(action: {
                            
                        }, label: {
                            HiImage(named: "ic_x_close")
                                .frame(width: 24, height: 24)
                        })
                    }
                    
                }
                
            }
            .onAppear(perform: {
                //Timer for recommend tip view
                self.recommendTipTimer.connect()
                .store(in: &recommendTipTimerCancelables)
                
                if !vm.isCheckingCompleted{
                    vm.processArr[0].status = .loading

                }
                
            })
            .backport.onChange(of: self.progress, perform: { progress in
                let progressPerProcess = 1.0 / Double(vm.processArr.count)
 
                if progress >=  progressPerProcess * (Double(currentProcessIndex) + 1.0) {
                    vm.processArr[currentProcessIndex].status = .active
                    
                    if currentProcessIndex < vm.processArr.count - 1{
                        currentProcessIndex += 1
                    }
                }
                
                if currentProcessIndex < vm.processArr.count - 1   {
                    vm.processArr[currentProcessIndex + 1].status = .waiting
                }
            })
            .hiFooter {
                switch vm.currentState {
                case .runningCheck:
                    return HiFooterTwoButtons(secondaryTitle: "Huỷ quét", secondaryAction: {
                        //MARK: - Cancel check
                        self.isStopProcess = true
                        self.resetProcess()
                        
                    }, primaryTitle: nil) {
                        
                    }
                    
                case .resultWithoutError:
                    return HiFooterTwoButtons(primaryTitle: "Tiếp tục báo lỗi") {
                        
                    }
                case .resultWithErrorHandledWithoutRecommend:
                    return HiFooterTwoButtons(secondaryTitle: "Tiếp tục báo lỗi", secondaryAction: {
                        
                    }, primaryTitle: "Hoàn tất") {
                        
                    }
                    
                case .resultNoErrorWithRecommends:
                    return HiFooterTwoButtons(primaryTitle: "Cần nhân viên hỗ trợ") {
                        
                    }
                }
            }

        }
        .onReceive(self.recommendTipTimer, perform: { value in
            if isShowRecommendTip {
                if recommendTipDurationCount <= 1 {
                    self.isShowRecommendTip = false
                }else {
                    recommendTipDurationCount -= 1
                }
            }else {
                recommendTipTimerCancelables.forEach {
                    $0.cancel()
                }
            }
            
        })
        .onReceive(vm.$isCheckingCompleted, perform: {  returnedIsCheckingCompleted in
            if returnedIsCheckingCompleted{
                self.finishChecking()
            }
        })
    
        .navigationBarHidden(true)
        .navigationBarTitle("")
        
    }

    private var contentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                HStack(spacing: 32) {
                    Button(action: {
                        if !isStopProcess {
                            self.isStopProcess = true
                        }else {
                            rushFinishChecking(duration: 1)
                        }
                    }, label: {
                        Text(isStopProcess ? "Rush 💨" : "Pause")
                    })

                    
                    Button {
//                        self.startCheckProgressStopAt(percentage: 0.8, duration: 8)
                        self.startCheckProgress()

                    } label: {
                        Text("Run check")
                    }
                    
                    Button {
                        self.resumeProgress(duration: 5, completion: {
                            finishChecking()
                            
                        })
                        
                    } label: {
                        Text("Resume")
                    }
                    
                }
                
                VStack(spacing: 24) {
                    ProcessView(progress: self.progress, processArr: vm.processArr, isCheckingCompleted: vm.isCheckingCompleted)
                    
                    
                        .padding(.horizontal, 27)
                    
                    
                    TextsProgressView(isCheckingCompleted: vm.isCheckingCompleted, descText: "Hệ thống đang kiểm tra lỗi. Vui lòng đợi trong giây lát.")
                    
                }
                .padding(EdgeInsets(top: 32, leading: 16, bottom: 24, trailing: 16))
                .background(Color.white)
                .cornerRadius(8)
                
                //MARK: - Detected and solved Block
                if !vm.detectedAndSolvedArr.isEmpty {
                    DrSmartBlock(blockTitle: "Phát hiện và xử lý thành công") {
                        VStack(spacing: 8) {
                            ForEach(vm.detectedAndSolvedArr, id: \.self) { item in
                                CircleCheckedLineView(text: item.text)
                            }
                        }
                    }
                }
                
                //MARK: - Recommends for handling block
                if !vm.recommendsForHandlingArr.isEmpty {
                    DrSmartBlock(blockTitle: "Gợi ý xử lý") {
                        VStack(spacing: 8) {
                            ForEach(vm.recommendsForHandlingArr, id: \.self) { item in
                                RecommendForHandlingView(type: item.type, title: item.title, descText: item.descText, btnText: item.btnText){
                                    if let actionModel = item.actionModel {
                                        delegate?.drSmartActionTracking(actionType: .recommendForHandling(actionModel))
                                    }
                                   
                                }
                            }
                        }
                    }
                }
                
                //MARK: - Not detect errror Block
                if !vm.notDetectErroArr.isEmpty {
                    DrSmartBlock(blockTitle: "Không phát hiện lỗi") {
                        VStack(spacing: 8){
                            ForEach(vm.notDetectErroArr, id: \.self) { item in
                                CircleCheckedLineView(text: item.title, subText: item.body)
                            }
                        }
                    }
                }
            }
            .padding(.all, 16)
            .padding(.bottom, 400)
            
        }
    }
    
    private var recommendTipView: some View {
        Group {
            if let recommend = vm.recommend  {
                if self.isShowRecommendTip {
                    Button {
                        delegate?.drSmartActionTracking(actionType: .recommendTip(ActionModel(actionName: "Tip View")))
                    } label: {
                        RecommendView(isShow: $isShowRecommendTip, type: recommend.type, title: recommend.title, descText: recommend.body)
                            .padding(.bottom, 16 + Constants.kHeightFooter1Button)
                            .padding(.horizontal, 16)
                    }
                }
            }
        }
       
    }
    
    
    
    
    private func startCheckProgress() {
        
        self.isStopProcess = false
        
    
        let updateInterval = 0.1
        let totalUpdates = Double(vm.checkDuration) / 0.1
        
        
        
        runProcess(updateInterval: updateInterval, duration: vm.checkDuration)
        
//        let dispatchQueue = DispatchQueue(label: "progressQueue", qos: .userInteractive)
//        dispatchQueue.async {
//            for _ in 0..<Int(totalUpdates) {
//                Thread.sleep(forTimeInterval: updateInterval)
//                
//                DispatchQueue.main.async {
//                    withAnimation {
//                        if !isStopProcess {
//                            progress += 1.0 / totalUpdates
//                        } else {
//                            return
//                        }
//                       
//                    }
//                }
//            }
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                if progress >= 1.0 && !isStopProcess {
//                    self.finishChecking()
//
//                }
//            }
//        }
    }
    
  
    
   
}

extension DrSmartScreen {
    private func runProcess(updateInterval: Double, duration: Int){
        let totalUpdates = Double(duration) / updateInterval
        
        let dispatchQueue = DispatchQueue(label: "progressQueue", qos: .userInteractive)
        dispatchQueue.async {
            for _ in 0..<Int(totalUpdates) {
                Thread.sleep(forTimeInterval: updateInterval)
                
                DispatchQueue.main.async {
                    withAnimation {
                        if !self.isStopProcess && progress < 1.0 {
                            progress += 1.0 / totalUpdates
                        } else {
                            return
                        }
                       
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                if progress >= 1.0 && !isStopProcess {
                    self.finishChecking()

                }
            }
        }
    }
    
    private func rushFinishChecking(duration: Int,  completion: (() -> Void)? =  nil) {
        self.isStopProcess = false
        
        if progress < 1.0 {            
            let updateInterval = 0.1
//            let totalUpdates = Double(duration) / updateInterval
            
            self.runProcess( updateInterval: updateInterval, duration: duration)
            
            
//            let dispatchQueue = DispatchQueue(label: "progressQueueRush", qos: .userInteractive)
//            dispatchQueue.async {
//                for _ in 0..<Int(totalUpdates) {
//                    Thread.sleep(forTimeInterval: updateInterval)
//                    
//                    DispatchQueue.main.async {
//                        withAnimation {
//                            if progress < 1.0 {
//                                progress += 1.0 / totalUpdates
//
//                            }
//                           
//                           
//                        }
//                    }
//                }
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                    if progress >= 1.0  {
//                        self.finishChecking()
//
//                    }
//                }
//            }
            
            
        }
    }
    
    //MARK: - Handle On Checking Completed
    private func finishChecking() {
        self.navTitle = "Kết quả kiểm tra"
        
        //Set current state for change footer view
        self.vm.currentState = .resultWithErrorHandledWithoutRecommend
        self.isShowRecommendTip = true
    }
    
    private func resetProcess() {
        self.vm.isCheckingCompleted = false
        self.progress = 0.0
        self.currentProcessIndex = 0
        
        for i in 0..<vm.processArr.count {
            if i == 0 {
                vm.processArr[0].status = .loading

            }else {
                vm.processArr[i].status = .inActive

            }
            
        }
    }
    
    private func startCheckProgressPauseAt(percentage: Double, duration: Int,completion: (() -> Void)? = nil)  {
        
        let updateInterval = 0.1
        let totalUpdates = Double(duration) / updateInterval
        
        let dispatchQueue = DispatchQueue(label: "progressQueue", qos: .userInteractive)
        
        // Start updating the progress using DispatchQueue
        dispatchQueue.async {
            for _ in 0..<Int(totalUpdates) {
                Thread.sleep(forTimeInterval: updateInterval)
                
                DispatchQueue.main.async {
                    withAnimation {
                        progress += percentage / totalUpdates
                    }
                }
            }
            completion?()
        }
    }
    

    
    
    /// Resume the checking process
    /// - Parameters:
    ///   - duration: seconds
    private func resumeProgress(duration: Int, completion: (() -> Void)? =  nil) {
        if progress < 1.0 {
            let progressUncompleted = 1.0 - progress
            
            let updateInterval = 0.1
            let totalUpdates = Double(duration) / updateInterval
            
            let dispatchQueue = DispatchQueue(label: "progressQueue", qos: .userInteractive)
            
            dispatchQueue.async {
                for _ in 0..<Int(totalUpdates) {
                    Thread.sleep(forTimeInterval: updateInterval)
                    
                    DispatchQueue.main.async {
                        withAnimation {
                            progress += progressUncompleted / totalUpdates
                        }
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    completion?()
                    finishChecking()
                    
                }
                
            }
            
            
        }
    }
}


struct DrSmartScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        DrSmartScreen()
    }
}



