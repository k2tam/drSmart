//
//  HiNavigationView.swift
//  SupportCenter
//
//  Created by k2 tam on 07/12/2023.
//

import SwiftUI

struct Constants {
    static let kHeightFooter1Button: CGFloat = 96
    static let kHeightFooter2Buttons: CGFloat = 122
    static let kContentToFooter: CGFloat = 40
}

enum eDirection {
    case vertical
    case horizontal
}


struct HiNavigationView<Content: View>: View {
    let content: Content
    @State private var showNavButton: Bool = true
    @State private var navButton: String = "ic_nav_left_arrow"
    @State private var title: String = ""
    @State private var trailingView: EquatableViewContainer = EquatableViewContainer(view: AnyView(EmptyView()))
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.hiBackground
            
            NavViewHeaderAndContent  
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .navigationBarTitle("")
    }
    
    
    
    private var NavViewHeaderAndContent: some View {
        VStack(spacing: 0){
            HiNavigationBarView(showNavButton: showNavButton, navButton: navButton, title: title, trailingView: trailingView)
            
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarHidden(true)
        .onPreferenceChange(HiNavBarTitlePreferenceKey.self, perform: { value in
            self.title = value
        })
        .onPreferenceChange(HiNavBarButtonHiddenPreferenceKey.self, perform: { value in
            self.showNavButton = !value
        })
        .onPreferenceChange(HiNavBarTrailingViewPreferenceKey.self, perform: { value in
            self.trailingView = value
        })
        .onPreferenceChange(HiNavBarBtnPreferenceKey.self, perform: { value in
            self.navButton = value
        })
    }
}



#Preview {
    HiNavigationView {
        ZStack{
            Color.purple.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            Text("Hi FPT")
                .foregroundColor(.white)
        }
    }
}


struct HiNavigationBarView: View {
    @Environment(\.presentationMode) var presentationMode
    let showNavButton: Bool
    let navButton: String
    let title: String
    let trailingView: EquatableViewContainer
    
    var body: some View {
        ZStack{
                        
            Text(title)
                .font(.system(size: 18, weight: .medium))
        
            
            HStack{
                if showNavButton {
                    backButton
                }
                
                Spacer()

                trailingView.view
            }
        }
        
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(Color.white)

      
    }
}


extension HiNavigationBarView {
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HiImage(string: self.navButton)
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(Color(hex: "#333333"))
        })
    }
    
    
}


extension View {
    func hiFooter<Content: View>(@ViewBuilder _ footerView: () -> Content) -> some View {
        ZStack(alignment: .bottom) {
            self
            
            ZStack{
                footerView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}






