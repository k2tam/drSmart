//
//  SVGImage.swift
//  SupportCenter
//
//  Created by k2 tam on 14/11/2023.
//

import SwiftUI

struct HiImageColorPreferenceKey: PreferenceKey {
    static var defaultValue: Color? = nil
    
    static func reduce(value: inout Color?, nextValue: () -> Color?) {
        value = nextValue()
    }
}

extension HiImage {
    func hiImageColor(color: Color) -> some View {
        self
            .preference(key: HiImageColorPreferenceKey.self, value: color) 
    }
}

public struct HiImage: View {
    var name: String
    @State var color: Color?
    var bundle: Bundle?
    
    public init(
        named name: String,
        color: Color? = nil,
        in bundle: Bundle? = nil
    ) {
        self.name = name
        self.color = color
        self.bundle = bundle
    }
    public var body: some View {
        ZStack {
            // image
            if #available(iOS 14.0, *) {
                Image(name)
                    .resizable()
            } else {
                Image(name)
                    .resizable()
                    .renderingMode(.original)
            }
            
            // color
            if let color = color {
                color.blendMode(.sourceAtop)
            }
        }
        .onPreferenceChange(HiImageColorPreferenceKey.self, perform: { value in
            self.color = value
        })
        .drawingGroup(opaque: false)
    }
}
 


