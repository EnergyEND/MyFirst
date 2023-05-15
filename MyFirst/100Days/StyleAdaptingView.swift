//
//  StyleAdaptingView.swift
//  MyFirst
//
//  Created by MAC on 03.04.2023.
//

import SwiftUI


struct StyleAdaptingView: View {
    @State private var size: CGFloat = 50
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                LottieView(animationName: "RainBack")
                
                VStack {
                    ViewThatFits {
                        Text("Very Very long text")
                        Text("Very long text")
                        Text("Medium text")
                        Text("Short")
                    }.frame(maxWidth: size)
                        .background(.mint)
                    
                    Slider(value: $size, in: 30...300).frame(maxWidth: 250)
                    
                    ViewThatFits {
                        VStack {
                            Text("Looooong text").font(.system(size: 40))
                            Text("Second text").font(.system(size: 25))
                        }.frame(width: 380)
                            .background(.blue)
                        VStack {
                            Text("Looooong text").font(.system(size: 25))
                            Text("Second text").font(.system(size: 15))
                        }.frame(width: 280)
                            .background(.blue)
                    }
                }
            }
        }
    }
}


struct StyleAdaptingView_Previews: PreviewProvider {
    static var previews: some View {
        StyleAdaptingView()
        
    }
}
