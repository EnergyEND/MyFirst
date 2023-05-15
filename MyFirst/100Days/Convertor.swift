//
//  Convertor.swift
//  MyFirst
//
//  Created by MAC on 05.01.2023.
//

import SwiftUI

enum TempChar: String, CaseIterable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    case kelvin = "Kelvin"
}

//MARK: Fuctions for convertation :
func celToFahr(temp: String) -> String {
    String(format: "%01.1f", (Double(temp) ?? 0) *  1.8 + 32)
}

func celToKel(temp: String) -> String {
    String(format: "%01.1f", (Double(temp) ?? 0) + 273)
}

func fahrToCel(temp: String) -> String {
    String(format: "%01.1f", ((Double(temp) ?? 0) - 32) / 1.8 )
}

func fahrToKel(temp: String) -> String {
    String(format: "%01.1f", ((Double(temp) ?? 0) - 32) * 5 / 9 + 273)
}

func kelToCel(temp: String) -> String {
    String(format: "%01.1f", (Double(temp) ?? 0) - 273)
}

func kelToFahr(temp: String) -> String {
    String(format: "%01.1f", ((Double(temp) ?? 0) - 273) * 1.8 + 32)
}

func sameChar(temp: String) -> String {
    String(format: "%01.1f", (Double(temp) ?? 0))
}


struct ConvertorView: View {
    
    let backColor = Color("ConvertorBack")
    @State public var inputChar: TempChar = .celsius
    @State public var outputChar: TempChar = .fahrenheit
    @State private var inputData = String()
    @State private var factor = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backColor.ignoresSafeArea()
                
                VStack{
                    if inputData != "" {
                        
                        HStack {
                            switch outputChar {
                            case .celsius:
                                switch inputChar {
                                    // Celsius - Celsius :
                                case .celsius :
                                    HStack{
                                        Text("Result:  \(sameChar(temp: inputData))")
                                    }
                                    // Fahrenheit - Celsius :
                                case .fahrenheit:
                                    HStack{
                                        Text("Result:  \(fahrToCel(temp: inputData))")
                                    }
                                    // Kelvin - Celsius :
                                case .kelvin:
                                    HStack{
                                        Text("Result:  \(kelToCel(temp: inputData))")
                                    }
                                }
                                Text("°C")
                                
                            case .fahrenheit:
                                switch inputChar {
                                    // Celsius - Fahrenheit :
                                case .celsius :
                                    HStack{
                                        Text("Result:  \(celToFahr(temp: inputData))")
                                    }
                                    // Fahrenheit - Fahrenheit :
                                case .fahrenheit:
                                    HStack{
                                        Text("Result:  \(sameChar(temp: inputData))")
                                    }
                                    // Kelvin - Fahrenheit :
                                case .kelvin:
                                    HStack{
                                        Text("Result:  \(kelToFahr(temp: inputData))")
                                    }
                                }
                                Text("°F")
                                
                            case .kelvin:
                                switch inputChar {
                                    // Celsius - Kelvin :
                                case .celsius :
                                    HStack{
                                        Text("Result:  \(celToKel(temp: inputData))")
                                    }
                                    // Fahrenheit - Kelvin :
                                case .fahrenheit:
                                    HStack{
                                        Text("Result:  \(fahrToKel(temp: inputData))")
                                    }
                                    // Kelvin - Kelvin :
                                case .kelvin:
                                    HStack {
                                        Text("Result:  \(sameChar(temp: inputData))")
                                    }
                                }
                                Text("°K")
                            }
                        }.disabled(inputData == "")
                            .padding()
                            .background()
                            .cornerRadius(15)
                            .padding(.bottom, 30)
                    }
                    HStack(spacing: 130){
                        HStack{
                            Text("Input")
                        }.foregroundColor(.blue)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.blue, lineWidth: 1))
                        
                        
                        HStack {
                            Text("Output")
                        }.foregroundColor(.red)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.red, lineWidth: 1))
                    }
                    
                    HStack{
                        Picker("Input", selection: $inputChar) {
                            ForEach(TempChar.allCases, id: \.self){ char in
                                Text(char.rawValue)
                            }
                        }.pickerStyle(.wheel)
                            .background()
                            .cornerRadius(15)
                        VStack{
                            Picker("Output", selection: $outputChar) {
                                ForEach(TempChar.allCases, id: \.self){ char in
                                    Text(char.rawValue)
                                }
                            }.pickerStyle(.wheel)
                                .background()
                                .cornerRadius(15)
                        }
                    }.padding()
                    TextField("Add your t°", text: $inputData).keyboardType(.decimalPad)
                        .padding()
                        .background()
                        .cornerRadius(15)
                        .padding()
                        .shadow(radius: 5)
                    HStack {
                        Button {
                            factor.toggle()
                            inputData = "\(Double(inputData)! * -1)"
                        } label: {
                            if factor {
                                Text("+")
                            } else {
                                Text("-")
                            }
                        }.disabled(inputData == "")
                            .buttonStyle(.bordered)
                            .tint(.blue)
                            .foregroundColor(.white)
                        
                        Button {
                            withAnimation {
                                inputData = ""
                            }
                        } label: {
                            Text("Clear")
                        }.buttonStyle(.bordered)
                            .tint(.blue)
                            .foregroundColor(.white)
                    }
                    
                }
            }
        }
    }
}

struct ConvertorView_Previews: PreviewProvider {
    static var previews: some View {
        ConvertorView()
    }
}
