//
//  ContentView.swift
//  MyFirst
//
//  Created by MAC on 20.09.2022.
//

import SwiftUI

//MARK: - Content View

struct ContentView: View {
    
    @StateObject private var userData = UserList()
    @State var isAdd = false
    var body: some View {
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
//                              .onChange(of: userData.users) { _ in
//                                  userData.save()
//                              }
                        }
                        NavigationLink("Cars"){
                            CarsView().navigationTitle("Cars").bold()
                        }
                        NavigationLink("Play with logo"){
                            ImageEditor().navigationTitle("Hold image for change it")
                        }
                        NavigationLink("Study test view"){
                            StudyView().navigationTitle("")
                        }
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

