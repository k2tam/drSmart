//
//  TestView.swift
//  DrSmart
//
//  Created by k2 tam on 23/01/2024.
//

import SwiftUI
import SwiftUIBackports
import Combine

class TestViewModel: ObservableObject {
    @Published var count: Int = 0
    @Published var isCounting: Bool = true
    
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var cancellable: AnyCancellable?
    var cancelables = Set<AnyCancellable>()
    
    init() {
        timer.sink { [weak self] value  in
            guard let self else {return}
            
            if self.isCounting {
                self.count += 1
                
            }
        }
        .store(in: &cancelables)
    }
    
    func cancel() {
        self.cancelables.forEach { cancelable in
            cancelable.cancel()
        }
    }
    
    func toggleRun() {
        self.isCounting.toggle()
    }
    
 
}

struct TestView: View {
    @Backport.StateObject var vm = TestViewModel()
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    Button(action: {
                         vm.cancel()

                    }, label: {
                        Text("End timer")
                    })
                    
                    Button(action: {
                        vm.toggleRun()
                    }, label: {
                        Text(vm.isCounting ? "Pause" : "Run")
                    })
                }
                
                
                Text("\(vm.count)")
                Text("Hi")
            }
        }
        
    }
    
}

#Preview {
    TestView()
}
