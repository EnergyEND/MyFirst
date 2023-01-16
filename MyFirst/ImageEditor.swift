//
//  ImageEditor.swift
//  MyFirst
//
//  Created by MAC on 10.10.2022.
//

import SwiftUI

let CQueue = DispatchQueue(label: "Concurrent queue", attributes: .concurrent)
let GQueue = DispatchQueue.global()

//MARK: - Custom button style
func MyButton (color : Color) -> some View{
    Button(""){
    }.frame(width: 50, height: 50)
     .background(color.gradient)
     .cornerRadius(10)
     .shadow(radius: 1)
}
//MARK: - Custom text style
struct SliderText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .shadow(radius: 0.1)
            
    }
}

//MARK: - Main editor view
struct ImageEditor: View {
    
    @State private var size : Double = 70
    @State private var shadow : CGFloat = 0.1
    @State private var angle : Double = 0
    @State private var shadowColor = Color.black
    @State private var backColor = Color.white
    @State private var image: String = "m.logo"
    @State private var isPress = false
    @State private var isHold = false
    
    //MARK: - Gesture for change image
    var longPress: some Gesture {
        LongPressGesture()
            .onEnded { value in
                isHold.toggle()
            }
    }
    
    var body: some View {
        ZStack{
            backColor.ignoresSafeArea()
            VStack{
                //MARK: - Main Image
                VStack{
                    Image(image)
                        .resizable()
                        .frame(width: size, height: size)
                        .shadow(color: shadowColor, radius: shadow)
                        .rotationEffect(.degrees(angle))
                        .padding(.vertical, 50)
                        .gesture(longPress)
                        .confirmationDialog("",isPresented: $isHold){
                            Button("Audi"){
                                self.image = "audi.logo"
                            }
                            Button("Mercedes"){
                                self.image = "merc.logo"
                            }
                            Button(role: .destructive){
                                self.image = "m.logo"
                            } label: {
                                Text("Reset")
                            }
                        }
                        
                }
                Spacer()
                //MARK: - Gauge's
                HStack(spacing: 60){
                    Gauge(value: size, in: 0...300){
                        Text("\(Int(size))")
                    }.gaugeStyle(.accessoryCircularCapacity).tint(.red).shadow(radius: 25)
                    Gauge(value: angle, in: -180...180){
                        Text("°").font(.system(size: 20))
                    } currentValueLabel: {
                        Text("\(Int(angle))")
                    }.gaugeStyle(.accessoryCircular).tint(.yellow).shadow(radius: 25)
                    Gauge(value: shadow, in: 0...10){
                        Text("\(Int(shadow * 10))%")
                    }.gaugeStyle(.accessoryCircularCapacity).tint(.green).shadow(radius: 25)
                }
                //MARK: - Background buttons
                HStack{
                    MyButton(color: .red)
                        .onTapGesture {CQueue.sync {backColor = .red}}
                    MyButton(color: .blue)
                        .onTapGesture {CQueue.sync {backColor = .blue}}
                    MyButton(color: .mint)
                        .onTapGesture {CQueue.sync {backColor = .mint}}
                    MyButton(color: .yellow)
                        .onTapGesture {CQueue.sync {backColor = .yellow}}
                    MyButton(color: .gray)
                        .onTapGesture {CQueue.sync {backColor = .gray}}
                    MyButton(color: .green)
                        .onTapGesture {CQueue.sync {backColor = .green}}
                }.frame(maxWidth: 350)
                
                //MARK: - Modifiers
                HStack(alignment: .center){
                    VStack(alignment: .leading, spacing: 20){
                        Text("Size:").modifier(SliderText())
                        Text("Angle:").modifier(SliderText())
                        Text("Shadow:").modifier(SliderText())
                        Text("SH Color:").modifier(SliderText())
                    }.padding(.leading, 10).padding(.vertical, 5)
                    VStack{
                        Slider(value: $size, in: 0...300).frame(maxWidth: 300).tint(.red)
                        Slider(value: $angle, in: -180...180).frame(maxWidth: 300).tint(.yellow)
                        Slider(value: $shadow, in: 0...10).frame(maxWidth: 300).tint(.green)
                        ColorPicker("", selection: $shadowColor)
                    }.padding(.trailing, 10)
                }.background(Material.regular).cornerRadius(15)
                    .frame(maxWidth: 350)
                //MARK: - Default button
                HStack{
                    Button{
                        withAnimation{
                            self.size = 70
                            self.shadow = 0.1
                            self.angle = 0
                            self.shadowColor = Color.black
                            self.backColor = Color.white
                        }
                    }label: {
                        Text("Reset settings")
                            .frame(width: 150,height: 40)
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.red)
                            .bold()
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}
struct ImageEditor_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditor()
    }
}
