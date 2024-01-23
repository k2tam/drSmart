//
//  DrSmartModel.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 17/01/2024.
//

import Foundation


enum eRecommendType: String {
    case info
    case error
}

struct DrSmartModel {
    var processes: [Process]
}


enum eDrSmartProcessStatus: String {
    case loading
    case waiting
    case active
    case inActive
}

struct Process: Identifiable {
    var id = UUID()
    var status: eDrSmartProcessStatus
    var activeIcon: String
    var inActiveIcon: String? = nil
}

struct DetectedAndSolved: Hashable {
    let text: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
}

struct CantHandleError: Hashable {
    let title: String
    let descText: String
    let btnText: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

struct NotDetectErroItem: Hashable {
    let title: String
    let body: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

struct Recommend {
    var type: eRecommendType
    let title: String
    let body: String
}
