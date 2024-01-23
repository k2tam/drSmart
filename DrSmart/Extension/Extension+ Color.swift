//
//  Extension+ Color.swift
//  SwiftUISupportCenter
//
//  Created by k2 tam on 16/01/2024.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

    
        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}

//Co trong hi themes

public extension Color {
    static let hiEEE = Color(red: 0.93, green: 0.93, blue: 0.93)
    static let hi282828 = Color(red: 0.16, green: 0.16, blue: 0.16)
    static let hi767676 = Color(red: 0.46, green: 0.46, blue: 0.46)
    static let hiC7CBCF = Color(red: 0.78, green: 0.8, blue: 0.81)
    static let hiAAA = Color(red: 170/255, green: 170/255, blue: 170/255)
    
    
    //Tambnk added
    static let hiPrimary = Color(red: 69/255, green: 100/255, blue: 237/255)
    static let hiBlueContainer = Color(red: 240/255, green: 243/255, blue: 254/255)

    static let hiSecondaryText = Color(red: 136/255, green: 136/255, blue: 136/255)

    static let hiBackground = Color(red: 245/255, green: 245/255, blue: 245/255)
    
    static let strokePrimary = Color(red: 209/255, green: 209/255, blue: 209/255)
    static let strokeLight = Color(red: 231/255, green: 231/255, blue: 231/255)
    
    static let hiPrimaryText = Color(red: 61/255, green: 61/255, blue: 61/255)
    
}
