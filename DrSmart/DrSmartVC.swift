//
//  DrSmartVC.swift
//  DrSmart
//
//  Created by k2 tam on 19/01/2024.
//

import UIKit
import SwiftUI

struct ActionModel {
    let actionName: String
}



class DrSmartVC: UIViewController {
    
    override func viewDidLoad() {
        print("hello")
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        var rootView = DrSmartScreen()
        rootView.delegate = self
        let vc = UIHostingController(rootView: rootView)
        let drSmartSwiftView = vc.view!
        
        drSmartSwiftView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(vc)
        view.addSubview(drSmartSwiftView)
        
        
        NSLayoutConstraint.activate([
            drSmartSwiftView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            drSmartSwiftView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drSmartSwiftView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drSmartSwiftView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        
        vc.didMove(toParent: self)
        
        

    }
}

extension DrSmartVC: DrSmartScreenDelegate {
    func fireDrSmartActionTracking(actionType: eDrSmartAction) {
        switch actionType {
        case .recommendForHandling(let actionModel):
            print("tambn DrSmartVC action tracking:  \(actionModel.actionName)")
        case .footerAction(let actionModel):
            print("tambn DrSmartVC action tracking:  \(actionModel.actionName)")
        case .recommendTip(let actionModel):
            print("tambn DrSmartVC action tracking:  \(actionModel.actionName)")
        }
    }
    
    
    
    
}
