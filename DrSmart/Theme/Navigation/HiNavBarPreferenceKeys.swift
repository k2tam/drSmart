//
//  HiNavigationBarPreferenceKeys.swift
//  SupportCenter
//
//  Created by k2 tam on 07/12/2023.
//

import Foundation
import SwiftUI


//Create an EquatableViewContainer we can use as preferenceKey data
struct EquatableViewContainer: Equatable {
    
    let id = UUID().uuidString
    let view:AnyView
    
    static func == (lhs: EquatableViewContainer, rhs: EquatableViewContainer) -> Bool {
        return lhs.id == rhs.id
    }
}

struct HiNavBarTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }

}

struct HiNavBarButtonHiddenPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }

}

struct HiNavBarTrailingViewPreferenceKey: PreferenceKey {
    static var defaultValue: EquatableViewContainer = EquatableViewContainer(view: AnyView(EmptyView()) )
    
    static func reduce(value: inout EquatableViewContainer, nextValue: () -> EquatableViewContainer) {
        value = nextValue()
    }
}

struct HiNavBarBtnPreferenceKey: PreferenceKey {
    static var defaultValue: String = "ic_nav_left_arrow"
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}


extension View {
    
    
    func hiNavigationTitle(_ title: String) -> some View{
        self
            .preference(key: HiNavBarTitlePreferenceKey.self, value: title)
    }
    
    func hiNavButtonHidden(_ hidden: Bool) -> some View{
        self
            .preference(key: HiNavBarButtonHiddenPreferenceKey.self, value: hidden)
    }
    
    func hiNavBarTrailingView<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        self
            .preference(key: HiNavBarTrailingViewPreferenceKey.self, value: EquatableViewContainer(view: AnyView(content())))
    }
    
    func hiNavButton(_ imgString: String) -> some View {
        self
            .preference(key: HiNavBarBtnPreferenceKey.self, value: imgString)
    }
    
    
}
