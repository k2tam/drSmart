//
//  DrSmartScreen.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 17/01/2024.
//

import SwiftUI
import SwiftUIBackports
import Lottie


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
    @State var progressQueue: DispatchQueue? = nil
    
    
    @Backport.StateObject var vm =  DrSmartViewModel()
    @State private var timer: Timer?
    @State private var progress: CGFloat = 0.0
    @State private var isShowRecommendTip: Bool = true
    @State private var currentProcessIndex: Int = 0
    
    //Navigation and footer props
    @State var navTitle: String = "Kiểm tra"
    @State var btnFooterPrimaryTitle: String? = nil
    @State var btnFooterSecondaryTitle: String? = "Huỷ quét"
    
    private func onCheckingCompleted() {
        self.navTitle = "Kết quả kiểm tra"
    }
    
    private func resetProcess() {
        self.timer?.invalidate()
        self.vm.isCheckingCompleted = false
        self.progress = 0.0
        self.currentProcessIndex = 0
        self.progressQueue = DispatchQueue(label: "progressQueue", qos: .userInteractive)
        
        for i in 0..<vm.processArr.count {
            vm.processArr[i].status = .inActive
        }
    }

    private var contentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                HStack(spacing: 32) {
                    NavigationLink {
                        TestView()
                    } label: {
                        Text("Nav")
                    }

                    
                    Button {
//                        self.startCheckProgressStopAt(percentage: 0.8, duration: 8)
                        
                                                            self.startCheckProgress()
                    } label: {
                        Text("Next Step")
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
    
    var body: some View {
        NavigationView {
            HiNavigationView {
                ZStack(alignment: .bottom) {
                    Color.hiBackground
                    contentView
                    recommendTipView
                }
                .hiNavigationTitle(self.navTitle)
                .hiNavButtonHidden(false)
                .hiNavBarTrailingView {
                    if vm.isCheckingCompleted {
                        Button(action: {
                            
                        }, label: {
                            HiImage(string: "ic_x_close")
                                .frame(width: 24, height: 24)
                        })
                    }
                    
                }
                
            }
            .onAppear(perform: {
            })
            .onDisappear(perform: {
                self.resetProcess()
                
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
                HiFooterTwoButtons(direction: .horizontal, primaryTitle: self.btnFooterPrimaryTitle, primaryAction: {
                    
                }, secondaryTitle: self.btnFooterSecondaryTitle) {
                    
                }
            }
        }
        
        .onReceive(vm.$isCheckingCompleted, perform: {  returnedIsCheckingCompleted in
            if returnedIsCheckingCompleted{
                self.onCheckingCompleted()
            }
        })
        .navigationBarHidden(true)
        .navigationBarTitle("")
        
    }
    
    private func startCheckProgress() {
        self.progressQueue = DispatchQueue(label: "progressQueue", qos: .userInteractive)
        
        
        let updateInterval = 0.1
        let totalUpdates = Double(vm.checkDuration) / updateInterval

        
        // Start updating the progress using DispatchQueue
        if let progressQueue = self.progressQueue {
            progressQueue.async {
                for _ in 0..<Int(totalUpdates) {
                    Thread.sleep(forTimeInterval: updateInterval)
                    
                    DispatchQueue.main.async {
                        withAnimation {
                            progress += 1.0 / totalUpdates
                        }
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.finishChecking()
                }
            }
        }
       
    }
    
    private func finishChecking() {
        vm.isCheckingCompleted = true
        timer?.invalidate()
    }
}

extension DrSmartScreen {
    private func startCheckProgressStopAt(percentage: Double, duration: Int,completion: (() -> Void)? = nil)  {
        
        //Reset process
        progress = 0.0
        vm.isCheckingCompleted = false
        
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
                    timer?.invalidate()
                    
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




struct AnimatePlaceholderModifier: AnimatableModifier {
    @Binding var isLoading: Bool
    
    @State private var isAnim: Bool = false
    private var center = (UIScreen.main.bounds.width / 2) + 110
    private let animation: Animation = .linear(duration: 1.5)
    
    init(isLoading: Binding<Bool>) {
        self._isLoading = isLoading
    }
    
    func body(content: Content) -> some View {
        content.overlay(animView.mask(content))
    }
    
    var animView: some View {
        ZStack {
            Color.black.opacity(isLoading ? 0.09 : 0.0)
            Color.white.mask(
                Rectangle()
                    .fill(
                        LinearGradient(gradient: .init(colors: [.clear, .white.opacity(0.48), .clear]), startPoint: .top , endPoint: .bottom)
                    )
                    .scaleEffect(1.5)
                    .rotationEffect(.init(degrees: 70.0))
                    .offset(x: isAnim ? center : -center)
            )
        }
        .animation(isLoading ? animation.repeatForever(autoreverses: false) : nil, value: isAnim)
        .onAppear {
            guard isLoading else { return }
            isAnim.toggle()
        }
        .backport.onChange(of: isLoading) { _ in
            isAnim.toggle()
        }
    }
}

extension View {
    func animatePlaceholder(isLoading: Binding<Bool>) -> some View {
        self.modifier(AnimatePlaceholderModifier(isLoading: isLoading))
    }
}
