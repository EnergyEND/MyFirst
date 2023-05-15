//
//  DiseView.swift
//  MyFirst
//
//  Created by MAC on 26.02.2023.
//

import SwiftUI
import CoreHaptics

//MARK: Models

struct Dice: Codable, Identifiable {
    var id = UUID()
    var sides: Int
    var element = Int()
    
    init(id: UUID = UUID(), sides: Int, element: Int) {
        self.id = id
        self.sides = sides
        self.element = Int.random(in: 1...sides)
    }
}

struct RollResult: Identifiable, Codable, Equatable {
    var id = UUID()
    var date = Date()
    var value : Int
}

class Dices: ObservableObject {
    @Published var dices = [Dice]()
}







//MARK: Main view
struct DiceView: View {
    @ObservedObject private var diceArray = Dices()
    @State private var sides = 2
    @State private var count = 1
    
    func getValues() -> [Int] {
        var tempValues = [Int]()
        for value in 1...sides {
            tempValues.append(value)
        }
        return tempValues
    }
    
    private var condition: Bool { diceArray.dices.isEmpty }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.blue, .mint, .white]), startPoint: .top, endPoint: .bottom))
                    .ignoresSafeArea()
                // Dices info:
                if !diceArray.dices.isEmpty {
                    
                    withAnimation{
                        HStack(spacing: 4) {
                            Text("You chose")
                            Text("\(count)").bold()
                            Text(count == 1 ? "dice" : "dices")
                            Text("with")
                            Text("\(sides)").bold()
                            Text("sides")
                        }.padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                            .background(.thickMaterial)
                            .cornerRadius(15)
                            .shadow(color: .mint,radius: 5)
                            .offset(y: 235)  //15
                    }
                }
                VStack {
                    // Hello block:
                    VStack(alignment: .center) {
                        HStack {
                            Text("Welcome to")
                            Text("DiceRoller").bold()
                        }
                        Text("Choose the number of sides\nand the number of dices.")
                        HStack(spacing: 5) {
                            Text("Click")
                            Text("Save").bold()
                            Text("and enjoy!!")
                        }
                    }.padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    
                    // Dice logo image:
                    Image(systemName: "dice.fill").resizable()
                        .foregroundStyle(.thickMaterial)
                        .shadow(radius: 55)
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(15))
                        .padding(.top, 30)
                        //.offset(y: 15)  //
                    
                    // Custom Stepper:
                    VStack {
                        HStack(spacing: 15) {
                            // minus button:
                            HStack {
                                Image(systemName: "dice")
                                Text("Sides:")
                            }.padding(.trailing, 80)
                            
                            Button {
                                if sides > 2  && sides <= 10 {
                                    sides -= 1
                                }
                            } label: {
                                Image(systemName: "minus").padding(EdgeInsets(top: 11, leading: 5, bottom: 11, trailing: 5))
                                    .background()
                                    .cornerRadius(5)
                                    .foregroundColor(.red)
                            }

                            // Sides gauge:
                            Gauge(value: Double(sides), in: 2...10){
                                Text("\(sides)")
                            }.gaugeStyle(.accessoryCircularCapacity).tint(.mint).shadow(radius: 25)
                                .background(.thickMaterial)
                                .cornerRadius(35)
                            
                            // plus button:
                            Button {
                                if sides >= 2 && sides < 10 {
                                    sides += 1
                                }
                            } label: {
                                Image(systemName: "plus").padding(5)
                                    .background()
                                    .cornerRadius(5)
                            }
                        }
                        
                        
                        HStack(spacing: 15) {
                            // minus button:
                            HStack {
                                Image(systemName: "dice")
                                Text("Count:")
                            }.padding(.trailing, 80)
                            
                            Button {
                                if count > 1  && count <= 6 {
                                    count -= 1
                                }
                            } label: {
                                Image(systemName: "minus").padding(EdgeInsets(top: 11, leading: 5, bottom: 11, trailing: 5))
                                    .background()
                                    .cornerRadius(5)
                                    .foregroundColor(.red)
                            }
                            
                            // Count gauge:
                            Gauge(value: Double(count), in: 1...6){
                                Text("\(count)")
                            }.gaugeStyle(.accessoryCircularCapacity).tint(.mint).shadow(radius: 25)
                                .background(.thickMaterial)
                                .cornerRadius(35)
                            
                            // plus button:
                            Button {
                                if count >= 1 && count < 6 {
                                    count += 1
                                }
                            } label: {
                                Image(systemName: "plus").padding(5)
                                    .background()
                                    .cornerRadius(5)
                            }
                            
                        }
                    }.padding()
                        .background(.thinMaterial)
                        .cornerRadius(20)
                    // line separator
                        .overlay {
                            Rectangle().fill(.mint.gradient).frame(height: 2)
                        }
                        .offset(y: 30)  //45
                    
                    Spacer()
                    
                    ///
                    
                    // Custom TabBar:
                    ZStack {
                        Rectangle().fill(.white)
                            .frame(height: 140)
                            .cornerRadius(25)
                            .offset(y: 50)
                            .shadow(radius: 45)
                        HStack(spacing: 40) {
                            // Save button:
                            Button {
                                diceArray.dices.removeAll()
                                for _ in 1...count {
                                    diceArray.dices.append(Dice(sides: sides, element: 0))
                                }
                                
                            } label: {
                                Text("Save")
                                    .foregroundColor(.gray)
                            }
                            .padding(8)
                            .background(.mint.gradient.opacity(0.2))
                            .cornerRadius(10)
                            
                            // Link button to RollView:
                            ZStack {
                                Rectangle()
                                    .fill(.mint.gradient)
                                    .opacity(0.6)
                                    .frame(width: 120, height: 45)
                                    .cornerRadius(25)
                                    .shadow(radius: condition ? 0 : 15)
                                    
                                    
                                NavigationLink {
                                    RollView(array: diceArray.dices)
                                } label: {
                                    Text("Let's roll")
                                        .font(.system(size: 20))
                                        .foregroundColor(condition ? .gray.opacity(0.3) : .white)
                                        .bold()
                                }
                                .disabled(diceArray.dices.isEmpty)
                                    .onAppear{
                                        sides = 2
                                        count = 1
                                    }
                            }
                            // Delete button:
                            Button(role: .destructive) {
                                diceArray.dices.removeAll()
                            } label: {
                                Text("Delete")
                            }.disabled(diceArray.dices.isEmpty)
                                .padding(8)
                                .background(.mint.gradient.opacity(0.2))
                                .cornerRadius(10)
                        }.padding(.top, 50)
                    }
                }.offset(y: 10)
            }.onAppear{diceArray.dices.removeAll()}
        }
    }
}

//MARK: Roll view
struct RollView: View {
    
    @State private var isRolling = false
    var array : [Dice]
    @State private var gridRows = Array(repeating: GridItem(.fixed(110)), count: 2)
    @State private var results = [RollResult]()
    @State private var angle: Double = 0
    
    func getResult() -> Int {
        var tempArray = [Int]()
        for dice in array {
            tempArray.append(dice.element)
        }
        return tempArray.reduce(0, +)
    }
    // Save json to Doc:
    func save() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(results)
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            let fileURL = documentDirectory.appendingPathComponent("rollResults.json")
            try jsonData.write(to: fileURL)
            print("Save successed")
        } catch {
            print("Error saving contacts: \(error)")
        }
    }
    // Read json from Doc:
    func load() {
        let jsonDecoder = JSONDecoder()
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent("rollResults.json")
            let jsonData = try Data(contentsOf: fileURL)
            let result = try jsonDecoder.decode([RollResult].self, from: jsonData)
            self.results = result
            print("Load successed")
        } catch {
            print("Error fetching contacts: \(error)")
        }
    }
    
    // Custom background image
    func backDice(angle: Double, x: Double, y: Double) -> some View {
        Image(systemName: "dice.fill").resizable()
            .foregroundStyle(.thickMaterial)
            .frame(width: 200, height: 200)
            .rotationEffect(.radians(angle))
            .opacity(0.6)
            .offset(x: x, y: y)
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.blue, .mint, .white]), startPoint: .top, endPoint: .bottom))
                    .ignoresSafeArea()
                
                backDice(angle: 3, x: -60, y: -220)
                backDice(angle: 20, x: 170, y: 50)
                backDice(angle: 10, x: -160, y: 250)
                
                if isRolling {
                    withAnimation {
                        HStack {
                            Text("Result: ")
                            Text("\(getResult())").bold()
                                .onAppear{
                                    results.insert(RollResult(value: getResult()), at: 0)
                                }
                        }.padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                            .background(.thickMaterial)
                            .cornerRadius(25)
                            .font(.system(size: 25))
                            .offset(y: -250)
                    }
                }
                
                VStack {
                    
                    LazyHGrid(rows: gridRows, spacing: 20) {
                        ForEach(array) { dice in
                            DiceBlockView(dice: dice, isRolling: $isRolling)
                                .rotationEffect(.degrees(angle))
                        }
                    }.padding(EdgeInsets(top: 70, leading: 0, bottom: 70, trailing: 0))
                    
                    // Roll button:
                    Button {
                        customVibro()
                        withAnimation(.easeInOut.repeatCount(5)) {
                            angle += 20
                        }
                        
                        angle -= 20
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7){
                            if !isRolling {
                                isRolling.toggle()
                            }
                        }

                    } label: {
                        Text("Roll").font(.system(size: 45)).bold()
                            .foregroundColor(isRolling ? .gray.opacity(0.7) : .blue)
                            .shadow(radius: 25)
                    }.disabled(isRolling)
                        .onAppear(perform: prepareHaptics)

                }.toolbar {
                    ToolbarItem {
                        NavigationLink {
                            ResultsView(array: $results).navigationTitle("Last rolls")
                        } label: {
                            HStack {
                                Text("Roll's").bold()
                            }
                                
                        }
                    }
                }
            }
        }.toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            load()
        }
        .onChange(of: results) { _ in
            save()
        }
    }
    @State private var engine: CHHapticEngine?
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func customVibro() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
}

struct DiceBlockView: View {
    var dice : Dice
    @Binding var isRolling : Bool
    lazy var random = Int.random(in: 1...dice.sides)
    var body: some View {
        ZStack {
            Rectangle().frame(width: 100, height: 100)
                .foregroundStyle(.thinMaterial)
                .cornerRadius(10)
                .shadow(radius: 15)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 3))
            Text(isRolling ? "\(dice.element)" : "?")
                .font(.largeTitle)
                .bold()
        }
    }
}

struct ResultsView: View {
    
    @Binding var array : [RollResult]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.blue, .mint, .white]), startPoint: .top, endPoint: .bottom))
                List {
                    ForEach(array) { res in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Date:")
                                Text("\(res.date.formatted(date: .abbreviated, time: .shortened))").bold()
                            }
                            HStack {
                                Text("Result:")
                                Text("\(res.value)").bold()
                            }
                        }
                    }.onDelete { indexSet in
                        array.remove(atOffsets: indexSet)
                    }
                }.scrollContentBackground(.hidden)
                    .shadow(radius: 15)
            }
        }.toolbar {
            ToolbarItem {
                EditButton()
            }
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView()
    }
}
