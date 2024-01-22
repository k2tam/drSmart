//
//  DrSmartVC.swift
//  DrSmart
//
//  Created by k2 tam on 19/01/2024.
//

import UIKit
import SwiftUI

class DrSmartVC: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        let vc = UIHostingController(rootView: DrSmartScreen())
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
