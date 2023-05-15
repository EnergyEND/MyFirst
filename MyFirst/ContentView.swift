//
//  ContentView.swift
//  MyFirst
//
//  Created by MAC on 20.09.2022.
//

import SwiftUI
import LocalAuthentication

//MARK: - Content View

struct ContentView: View {
    
    @StateObject private var userData = UserList()
    @State private var isUnlocked =  false
    @State private var newTry = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    newTry = true
                }
            }
        } else {
            print("Unlocked without biometrics")
            isUnlocked = true
        }
    }
    
    
    var body: some View {
        VStack {
            if isUnlocked {
                VStack {
                    NavigationStack{
                        List{
                            HStack{
                                Image(systemName: "apple.logo")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("MyFirst 1.0")
                                Text("Hello, world!").bold()
                            }.listRowBackground(Color.mint).foregroundColor(.white)
                            
                            Section("Menu"){
                                NavigationLink("Add new User"){
                                    AddUserView(content: userData).navigationTitle("User info")
                                        .onChange(of: userData.users) { _ in
                                            userData.save()
                                        }
                                }
                                NavigationLink("All Users"){
                                    Users(content: userData).navigationTitle("All Users").bold()
                                        .task {
                                            userData.load()
                                        }
                                }
                                NavigationLink("Cars"){
                                    CarsView().navigationTitle("Cars").bold()
                                }
                                NavigationLink("Play with logo"){
                                    ImageEditor().navigationTitle("Hold image for change it")
                                }
                                NavigationLink("100 days view's"){
                                    StudyView().navigationTitle("")
                                }
                            }
                        }
                    }
                }
            }else {
                ZStack {
                    Rectangle()
                        .fill(Color.mint.gradient).ignoresSafeArea()
                    VStack {
                        Image(systemName: "faceid").font(.system(size: 90))
                        Text(newTry ? "FaceID error" : "Locked")
                        if newTry {
                            Button {
                                authenticate()
                            } label: {
                                Text("Try again")
                                    .padding(5)
                                    .background(.thinMaterial)
                                    .cornerRadius(10)
                            }

                        }
                    }
                }
            }
        }
        .onAppear(perform: authenticate)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

