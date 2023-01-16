//
//  LoadingView.swift
//  MyFirst
//
//  Created by MAC on 27.09.2022.
//

import SwiftUI

struct LoadingView: View {
    @State private var isActive : Bool = false
    @State private var size = 0.7
    @State private var opacity = 0.4
    var body: some View {
        if isActive {
            ContentView()
        }else {
            ZStack{
                Color.mint.ignoresSafeArea()
                VStack(alignment: .center, spacing: 20){
                    Text("MyFirst").font(.largeTitle).italic()
                        .padding(.top, 150)
                    Image(systemName: "apple.logo")
                        .font(.custom("LoadScreen", size: 90))
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.2)) {
                                self.size = 1.1
                                self.opacity = 1.0
                            }
                        }
                    
                    ProgressView().tint(.white)
                        .scaleEffect(2)
                        .padding(.top, 200)
                }.foregroundColor(.white)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
