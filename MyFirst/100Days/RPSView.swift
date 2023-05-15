//
//  RPSView.swift
//  MyFirst
//
//  Created by MAC on 17.01.2023.
//

import SwiftUI

enum Moves {
    case rock
    case paper
    case scissors
    case none
}

enum Result {
    case win
    case lose
    case tie
    case none
}


struct RpsView: View {
    
    @State private var result: Result = .none
    @State private var start = false
    @State private var startPulse: CGFloat = 2
    @State private var score = 0
    @State private var playerMove: Moves = .none
    @State private var enemyMove: Moves = .none
    @State private var move = 0
    @State private var resultText = String()
    @State private var labelBack = Color("labelRect")
    
    
    
    func getResult(text: String, color: Color){
        self.resultText = text
        withAnimation {
            labelBack = color
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            result = .none
            labelBack = Color("labelRect")
        }
    }
    
    //
    func rules(image: String, color: Color, move: Moves, win: Moves, lose: Moves) -> some View{
        Image(systemName: image).foregroundColor(color).scaleEffect(5)
            .onAppear{
                enemyMove = move
                
                if enemyMove == playerMove {result = .tie}
                else if playerMove == win {result = .win}
                else if playerMove == lose {result = .lose}
            }
    }
    
    // Player move buttons
    func moveButton(move: Moves, image: String, color: String) -> some View {
        Button {
            playerMove = move
            self.move = Int.random(in: 1...3)
        }label: {
            ZStack {
                Circle().frame(width: 40, height: 40).foregroundColor(.white).opacity(0.1)
                Image(systemName: image).foregroundColor(Color(color))
            }.scaleEffect(1.4)
        }
    }
    
    
    var body: some View {
    
        ZStack {
            Color("RPSback").ignoresSafeArea()
            
            //MARK: - Start button
            if start == false {
                
                Button {
                    start.toggle()
                } label: {
                    Text("START")
                        .foregroundColor(.mint)
                        .padding(EdgeInsets(top: 15, leading: 30, bottom: 15, trailing: 30))
                        .background(.thickMaterial)
                        .cornerRadius(10)
                        .scaleEffect(startPulse)
                        .shadow(radius: 3)
                }.onAppear{
                    withAnimation(.easeInOut.repeatForever(autoreverses: true)) {
                        startPulse = 1.25 * startPulse
                    }
                }

            }else {
                
                VStack {
                    //MARK: - Score label
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 300, height: 80)
                            .foregroundColor(labelBack)
                            .opacity(0.7)
                        HStack(spacing: 30){
                            Text("Your score:")
                            Text("\(score)")
                        }
                    }.font(.largeTitle)
                        .padding(.bottom, 30)
                    
                    
                    ZStack(alignment: .center){
                        
                        Rectangle().frame(width: 360, height: 400)
                            .foregroundColor(Color("labelRect"))
                            .cornerRadius(10)
                            .padding(.bottom, 50)
                    
                        
                        //MARK: - Result message
                        if result != .none {
                            withAnimation {
                                Text("\(resultText)")
                                    .offset(y: -120)
                                    .padding(-5)
                                    .font(.largeTitle)
                                    .foregroundColor(.mint)
                            }.onAppear{
                                switch result {
                                case .win:
                                    getResult(text: "You win !!!", color: .green)
                                    score += 1
                                    
                                case .lose:
                                    getResult(text: "You lose...", color: .red)
                                    if score > 0 {score -= 1}
                                    
                                case .tie:
                                    getResult(text: "Tie.", color: .yellow)
                                    
                                default: resultText = ""
                                }
                            }
                        }
                        
                        
                        //MARK: - Game rules
                        if enemyMove == .none && playerMove == .none {
                            Text("Choose your move below").padding(.bottom, 30).font(.headline)
                        }else {
                            switch move {
                            case 1:
                                withAnimation {
                                    rules(image: "scissors", color: .red, move: .scissors, win: .rock, lose: .paper)
                                }
                            case 2:
                                withAnimation {
                                    rules(image: "newspaper.fill", color: .mint, move: .paper, win: .scissors, lose: .rock)
                                }
                            default:
                                withAnimation {
                                    rules(image: "mountain.2.fill", color: .purple, move: .rock, win: .paper, lose: .scissors)
                                }
                            }
                        }
                    }
                    
                    //MARK: - Player moves bar
                    HStack(spacing: 35){
                        
                        moveButton(move: .scissors, image: "scissors", color: "scissors")

                        moveButton(move: .paper, image: "newspaper.fill", color: "paper")

                        moveButton(move: .rock, image: "mountain.2.fill", color: "rock")
                        
                    }.padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                    .background(.ultraThickMaterial)
                    .cornerRadius(10)
                    .scaleEffect(1.3)
                }
            }
        }
    }
}

struct RpsView_Previews: PreviewProvider {
    static var previews: some View {
        RpsView()
    }
}
