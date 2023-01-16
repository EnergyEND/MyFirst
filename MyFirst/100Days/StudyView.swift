//
//  CalculatorView.swift
//  MyFirst
//
//  Created by MAC on 06.11.2022.
//

import SwiftUI

struct StudyView: View {
    @State private var flag = false
    
    var body: some View {
        VStack {
            Text(verbatim: "Hello World !!")
                .font(.largeTitle)
                .fontWeight(flag ? .black : .light)
                .foregroundColor(flag ? .yellow : .red)
                .onTapGesture {
                    withAnimation(.default.speed(0.5)) {
                        flag.toggle()
                        print("test")
                    }
                }
        }
        List {
            Section ("100 Days projects") {
                NavigationLink("Convertor") {
                    ConvertorView().navigationTitle("Convertor")
                }
            }
        }
        .contentTransition(.interpolate)
    }
}

struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView()
    }
}
