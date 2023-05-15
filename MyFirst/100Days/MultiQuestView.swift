//
//  MultiQuestView.swift
//  MyFirst
//
//  Created by MAC on 19.01.2023.
//

import SwiftUI


struct Quest: Identifiable {
    var id = UUID()
    
    var first: Int
    var second: Int
    
    func getAnswer() -> Int {
        first * second
    }
}


class Questions: Identifiable, ObservableObject {
    @Published var range: [Int] = [2,3,4,5,6,7,8,9,10,11,12,13]
    @Published var table = [Quest]()
}


struct MultiQuestView: View {
    
    @ObservedObject private var quest = Questions()
    @State private var quantity = 1
    @State private var start = false
    @State private var currentTable = 0
    @State private var gridColumns = Array(repeating: GridItem(.fixed(70)), count: 4)
    
    @State private var answer = Int()
    @State private var index = Int()
    @State private var counter = Int()
    
    
    func createQuests() {
        for i in 1...quantity {
            var ind = i
            quest.table.append(Quest(first: currentTable, second: ind))
            ind += 1
        }
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color("questBack").ignoresSafeArea()
                
                if !start {
                    VStack{
                        
                        VStack {
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 320, height: 60)
                                    .foregroundColor(Color("labelRect"))
                                Text("Which table do you want to learn ?")
                                    .font(.title3)
                            }.padding(.bottom, 30)
                            
                            LazyVGrid(columns: gridColumns){
                                ForEach(quest.range, id: \.self) { num in
                                    
                                    Button {
                                        currentTable = num
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(num == currentTable ? .green : Color("labelRect"))
                                            Text("\(num)")
                                                .foregroundColor(Color("questButton"))
                                                .font(.title2)
                                        }
                                    }
                                    
                                }
                            }.padding(.bottom, 40)
                            
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 350, height: 80)
                                .foregroundColor(Color("labelRect"))
                            
                            VStack {
                                Stepper("Quantity of tests:   \(quantity)", value: $quantity, in: 1...20)
                                    .frame(width: 300)
                            }
                        }.padding(.bottom, 70)
                        
                        
                        Button {
                            start.toggle()
                            createQuests()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 300, height: 100)
                                    .foregroundColor(Color("labelRect"))
                                
                                Text(currentTable == 0 ? "Select table" : "Ready !")
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color("questButton"))
                            }
                        }.disabled(currentTable == 0)
                    }
                    
                }else if index < quest.table.count{
                    VStack{
                        
                        HStack{
                            Text("Correct answers:   ")
                            Text("\(counter)").bold()
                        }
                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                        .background(.regularMaterial)
                        .cornerRadius(15)
                        .offset(y: -200)
                        .font(.title2)
                        
                        Text("Question \(index + 1) / \(quantity)")
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(15)
                            .font(.custom("", size: 17))
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 220, height: 75)
                                .foregroundColor(answer == quest.table[index].getAnswer() ? .green : Color("labelRect"))
                            
                            Text("\(quest.table[index].first) ∗ \(quest.table[index].second) =   \(answer == quest.table[index].getAnswer() ? "\(answer)" : "?" )")
                                .font(.largeTitle).bold()
                            
                        }.onChange(of: answer) { _ in
                            if answer == quest.table[index].getAnswer() {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    index += 1
                                    counter += 1
                                }
                            }
                        }
                        
                        HStack {
                            Text("Enter the answer:").offset(x: -25)
                            TextField("......", value: $answer, formatter: NumberFormatter())
                                .frame(width: 70)
                                .keyboardType(.decimalPad)
                        }.padding(EdgeInsets(top: 20, leading: 50, bottom: 20, trailing: 50))
                            .background()
                            .cornerRadius(15)
                            .font(.title2)
                        
                    }.onAppear{
                        print(quest.table)
                    }
                    
                }else {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 300, height: 100)
                            .foregroundColor(Color("labelRect"))
                        Text("Congratulation !!!")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(Color("questButton"))
                    }
                }
            }
        }
    }
}



struct MultiQuestView_Previews: PreviewProvider {
    static var previews: some View {
        MultiQuestView()
    }
}
