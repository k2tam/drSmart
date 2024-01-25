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
    func fireDrSmartActionTracking(actionType: eDrSmartAction)
}

struct DrSmartScreen: View {
    
    var delegate: DrSmartScreenDelegate?
    @State var isCancelCheckProgress: Bool = false
    
    
    @Backport.StateObject var vm =  DrSmartViewModel()
    @State private var displayProgress: Float = 0.0
    @State private var currentProcessIndex: Int = 0
    
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
                            self.currentProcessIndex = 0
                            vm.cancelChecking()
                            
                        }, label: {
                            HiImage(named: "ic_x_close")
                                .frame(width: 24, height: 24)
                        })
                    }
                    
                }
            }
            .onAppear(perform: {
                if !vm.isCheckingCompleted{
                    vm.processArr[0].status = .loading
                    
                }
            })
            .onReceive(vm.$progress, perform: { returnedProgress in
                withAnimation {
                    self.displayProgress = returnedProgress
                    
                    let progressPerProcess = 1.0 / Float(vm.processArr.count)
                    
                    if returnedProgress >=  progressPerProcess * Float((Double(currentProcessIndex) + 1.0)) {
                        vm.processArr[currentProcessIndex].status = .active
                        
                        if currentProcessIndex < vm.processArr.count - 1{
                            currentProcessIndex += 1
                        }
                    }
                    
                    if currentProcessIndex < vm.processArr.count - 1   {
                        vm.processArr[currentProcessIndex + 1].status = .waiting
                    }
                }
                
                
                
            })
            .hiFooter {
                switch vm.currentState {
                    
                case .runningCheck:
                    return HiFooterTwoButtons(secondaryTitle: "Huỷ quét", secondaryAction: {
                        //MARK: - Cancel check
                        vm.cancelChecking()
                        delegate?.fireDrSmartActionTracking(actionType: .footerAction(ActionModel(actionName: "Huỷ quét")))
                    }, primaryTitle: nil) {
                        
                    }
                    
                case .resultWithoutError:
                    return HiFooterTwoButtons(primaryTitle: "Tiếp tục báo lỗi") {
                        delegate?.fireDrSmartActionTracking(actionType: .footerAction(ActionModel(actionName: "Tiếp tục báo lỗi")))
                        
                    }
                case .resultWithErrorHandledWithoutRecommend:
                    return HiFooterTwoButtons(secondaryTitle: "Tiếp tục báo lỗi", secondaryAction: {
                        delegate?.fireDrSmartActionTracking(actionType: .footerAction(ActionModel(actionName: "Tiếp tục báo lỗi")))
                    }, primaryTitle: "Hoàn tất") {
                        delegate?.fireDrSmartActionTracking(actionType: .footerAction(ActionModel(actionName: "Hoàn tất®")))
                        
                    }
                    
                case .resultNoErrorWithRecommends:
                    return HiFooterTwoButtons(primaryTitle: "Cần nhân viên hỗ trợ") {
                        delegate?.fireDrSmartActionTracking(actionType: .footerAction(ActionModel(actionName: "Cần nhân viên hỗ trợ")))
                        
                    }
                }
            }
            
        }
        
        .onReceive(vm.$isCheckingCompleted, perform: {  returnedIsCheckingCompleted in
            if returnedIsCheckingCompleted{
                self.onFinishChecking()
            }
        })
        
        .navigationBarHidden(true)
        .navigationBarTitle("")
        
    }
    
    private var contentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                //MARK: - Testing Buttons
                VStack {
                    HStack(spacing: 32) {
                        
                        Button(action: {
                            self.vm.runChecking(duration: 1)
                        }, label: {
                            Text("Rush")
                        })
                        
                        Button(action: {
                            self.vm.runCheckingTo(percentage: 0.6, duration: 4)
                            
                        }, label: {
                            Text("Run to %")
                        })
                        
                        Button {
                            vm.stopChecking()
                        } label: {
                            Text("Stop")
                        }
                        
                        Button {
                            self.vm.runChecking(duration: vm.checkingDuration)
                            
                        } label: {
                            Text("Run check")
                        }
                        
                        
                    }
                    
                    Text("\(self.displayProgress)")
                }
                
                
                VStack(spacing: 24) {
                    ProcessView(progress: self.displayProgress, processArr: vm.processArr, isCheckingCompleted: vm.isCheckingCompleted)
                    
                    
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
                                        delegate?.fireDrSmartActionTracking(actionType: .recommendForHandling(actionModel))
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
                Button {
                    delegate?.fireDrSmartActionTracking(actionType: .recommendTip(ActionModel(actionName: "Tip View")))
                } label: {
                    RecommendView(type: recommend.type, title: recommend.title, descText: recommend.body, dismissAction: vm.removeRecommendTipBySwipe)
                        .padding(.bottom, 16 + Constants.kHeightFooter1Button)
                        .padding(.horizontal, 16)
                }
                 
            }
        }
        
    }
}

extension DrSmartScreen {
    //MARK: - Handle On Checking Completed
    private func onFinishChecking() {
        self.navTitle = vm.isCheckingCompleted ? "Kết quả kiểm tra" : "Kiểm tra"
        //Set current state for change footer view
        self.vm.currentState = .resultWithErrorHandledWithoutRecommend
    }
}


struct DrSmartScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        DrSmartScreen()
    }
}



