//
//  CalculatorView.swift
//  MyFirst
//
//  Created by MAC on 06.11.2022.
//

import SwiftUI

struct StudyView: View {
    @State private var flag = false
    @ObservedObject private var activityList = ActivityList()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(verbatim: "Hello World !!")
                    .font(.largeTitle)
                    .fontWeight(flag ? .black : .light)
                    .foregroundColor(flag ? .yellow : .red)
                    .onTapGesture {
                        withAnimation(.default.speed(0.5)) {
                            flag.toggle()
                        }
                    }
            }.padding()
            List {
                Section ("100 Days projects") {
                    NavigationLink("Convertor") {
                        ConvertorView().navigationTitle("Convertor")
                    }
                    NavigationLink("Rock, Paper, Scissors") {
                        RpsView().navigationTitle("Let's play!")
                    }
                    NavigationLink("MultiQuest") {
                        MultiQuestView().navigationTitle("")
                    }
                    NavigationLink("Activities") {
                        ActivitiesView().navigationTitle("")
                    }
                    NavigationLink("Users DB") {
                        UsersDBView().navigationTitle("")
                    }
                    NavigationLink("Contacts") {
                        ContactsPackView().navigationTitle("")
                    }
                    NavigationLink("DiceRoller") {
                        DiceView().navigationTitle("")
                    }
                    NavigationLink("All in 1") {
                        AllInOneView().navigationTitle("")
                    }
                    NavigationLink("Adapting") {
                        StyleAdaptingView().navigationTitle("")
                    }
                }
            }
            //.scrollContentBackground(.hidden)
        }
    }
}

struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView()
    }
}
