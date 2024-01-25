//
//  LottieView.swift
//  DrSmart
//
//  Created by k2 tam on 19/01/2024.
//

import SwiftUI
import Lottie


struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat = 0.7
    
    func makeUIView(context: Context) -> some UIView {
        UIView()
       
    }
    
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        let animationView = LottieAnimationView()
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        uiView.addSubview(animationView)
//
//        NSLayoutConstraint.activate([
//            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
//            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
//        ])
//        
//        DotLottieFile.loadedFrom(url: url) { result in
//            switch result {
//            case .success(let success):
//                animationView.loadAnimation(from: success)
//                animationView.play()
//            case .failure(let failure):
//                print(failure)
//            }
//        }
//        
//    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
               do {
                   let animationFile = try LottieAnimation.named("")
                   DispatchQueue.main.async {
                       animationView.animation = animationFile
                       animationView.loopMode = .loop
                       animationView.animationSpeed = animationSpeed
                       animationView.play()
                   }
               } catch {
                   print("Failed to load Lottie animation from JSON file: \(error)")
               }
           } else {
               print("Lottie JSON file 'map.json' not found in the bundle.")
           }
        
    }
}
