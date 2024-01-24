//
//  TestHiImage.swift
//  DrSmart
//
//  Created by k2 tam on 24/01/2024.
//

import SwiftUI

struct TestHiImage: View {
    var body: some View {
            HiImage(named: "ic_linear_router", color: Color.blue)
                .frame(width: 50, height: 50)
         
       
    }
}

#Preview {
    TestHiImage()
}
