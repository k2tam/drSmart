//
//  DrSmartScreen.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 17/01/2024.
//

import SwiftUI
import SwiftUIBackports
import Lottie

struct DrSmartScreen: View {
    @Backport.StateObject var vm =  DrSmartViewModel()
    @State private var timer: Timer?
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.hiBackground
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Button {
                        self.startCheckProgress()
                        
                    } label: {
                        Text("Next Step")
                    }
                    
                    VStack(spacing: 24) {
                        ProcessView

                        TextsView
                            
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
                    
                    //MARK: - Unhandled Error Block
                    if !vm.cantHandleErrorArr.isEmpty {
                        DrSmartBlock(blockTitle: "Lỗi chưa thể xử lý") {
                            VStack(spacing: 8) {
                                ForEach(vm.cantHandleErrorArr, id: \.self) { item in
                                    UnhandledErrorView(title: item.title, descText: item.descText, btnText: item.btnText) {
                                    }
                                }
                            }
                        }
                    }
                    
                    //MARK: - Not detect rrror Block
                    if !vm.notDetectErroArr.isEmpty {
                        DrSmartBlock(blockTitle: "Không phát hiện lỗi!") {
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
            
            
            
            if let recommend = vm.recommend {
                RecommendView(type: recommend.type, title: recommend.title, descText: recommend.body)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 16)
            }
        }
     
        
    }
    
    private var TextsView: some View {
        VStack(spacing: 8){
            Text(vm.isCheckingCompleted ? "Hoàn tất" : "Đang kiểm tra..." )
                .font(.system(size: 20, weight: .semibold))
            
            if !vm.isCheckingCompleted {
                Text("Hệ thống đang kiểm tra lỗi. Vui lòng đợi trong giây lát.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    .foregroundColor(Color.hiSecondaryText)
            }
            
        }
    }

    private var ProcessView: some View {
        VStack(spacing: 24) {
            HStack {
                ForEach(Array(vm.processArr.enumerated()) ,id: \.element.id) { index, process in
                    DrSmartProcessItem(status: process.status,activeImg: process.activeIcon, inActiveImg: process.inActiveIcon)
                    
                    
                    if index != vm.processArr.count - 1 {
                        Spacer()
                    }
                }
            }
            
            if !vm.isCheckingCompleted {
                GeometryReader {geo in
                    Capsule()
                        .foregroundColor(Color(hex: "#DDE4FC"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 4)
                        .padding(.all, 8)
                        .backport.overlay(alignment: .leading) {
                            Capsule()
                                .foregroundColor(.blue)
                                .frame(height: 4)
                                .frame(width: (geo.size.width  * progress))
                        }
                }
                
            }
            
        }
        
    }



    func startCheckProgress() {
        //Reset process
        progress = 0.0
        vm.isCheckingCompleted = false
        
        let updateInterval = 0.1
        let totalUpdates = Double(vm.checkDuration) / updateInterval
        
        let dispatchQueue = DispatchQueue(label: "progressQueue", qos: .userInteractive)
           
           // Start updating the progress using DispatchQueue
           dispatchQueue.async {
               for _ in 0..<Int(totalUpdates) {
                   Thread.sleep(forTimeInterval: updateInterval)
                   
                   DispatchQueue.main.async {
                       withAnimation {
                           progress += 1.0 / totalUpdates
                       }
                   }
               }
               
               DispatchQueue.main.async {
                   vm.isCheckingCompleted = true
               }
           }
    }

    
}



#Preview {
    DrSmartScreen(vm: DrSmartViewModel())
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
