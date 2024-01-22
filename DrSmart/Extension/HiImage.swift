//
//  SVGImage.swift
//  SupportCenter
//
//  Created by k2 tam on 14/11/2023.
//

import SwiftUI

public struct HiImage: View {
    var string: String
    
    public init(
        string: String
    ) {
        self.string = string
    }
    public var body: some View {
        if #available(iOS 14.0, *) {
            Image(string)
                .resizable()
        } else {
            Image(string)
                .resizable()
                .renderingMode(.original)
            
        }
    
    }
}
 
