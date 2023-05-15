//
//  LottieView.swift
//  MyFirst
//
//  Created by MAC on 13.05.2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    var animationName: String = "myAnimation"
    let view = LottieAnimationView()
    
    func makeUIView(context: Context) -> some UIView {
        view.animation = LottieAnimation.named(animationName)
        //view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        
        view.play()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: view.widthAnchor),
            view.heightAnchor.constraint(equalTo: view.heightAnchor),
            view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView()
    }
}
