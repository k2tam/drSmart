//
//  TestVC.swift
//  DrSmart
//
//  Created by k2 tam on 19/01/2024.
//

import UIKit
import Lottie

class TestVC: UIViewController {
    private lazy var animView: LottieAnimationView = {
        let lotV = LottieAnimationView()
        lotV.translatesAutoresizingMaskIntoConstraints = false
        lotV.loopMode = .loop
        lotV.backgroundColor = .white
        return lotV
    }()
    
    private lazy var btnNav: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .blue
        btn.setTitle("To Dr Smart", for: .normal)
        return btn
    }()
    
    func setupAnimView() {
        if let animation = LottieAnimation.named("Scan_Small") {
            animView.animation = animation
        }
        
        animView.play()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNav.addTarget(self, action: #selector(btnNavTapped), for: .touchUpInside)
        
        
        setupAnimView()
        
        view.addSubview(animView)
        view.addSubview(btnNav)
        
        
        NSLayoutConstraint.activate([
            animView.widthAnchor.constraint(equalToConstant: 100),
            animView.heightAnchor.constraint(equalToConstant: 100),
            
            animView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            animView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            btnNav.widthAnchor.constraint(equalToConstant: 200),
            btnNav.heightAnchor.constraint(equalToConstant: 50),
            
            btnNav.topAnchor.constraint(equalTo: animView.bottomAnchor, constant: 50),
            btnNav.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        
        
        
    }
    
    @objc func btnNavTapped() {
        // Handle button tap action
        let drSmartVC = DrSmartVC()
        self.navigationController?.pushViewController(drSmartVC, animated: true)
    }
    
    
    
    
}
