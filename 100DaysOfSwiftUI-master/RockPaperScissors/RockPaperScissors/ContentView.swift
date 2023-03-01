//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Boe Bogdin on 1/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var computersChoice = Int.random(in: 0..<3)
    @State private var userShouldWin = Bool.random()
    @State private var score = 0
    @State private var showWrong = false;
    @State private var showCorrect = false;
    
    var options = ["Rock", "Paper", "Scissors"]
    var winningMoves = ["Paper", "Scissors", "Rock"]
    
    
    var body: some View {
        VStack {
            Text("Rock, Paper, Scissors!!!").padding()
                
            userShouldWin ? Text("You need to win!").padding() : Text("You need to lose!").padding()
            
            HStack {
                ForEach(0..<options.count) { index in
                    Button(options[index]) {
                        //Do Stuff
                        determineOutcome(usersChoice: options[index])
                    }
                }
            }.padding()
            
            Text("Score: \(score)")
        }
        .alert("Wrong! I chose \(options[computersChoice])", isPresented: $showWrong) {
            Button("Okay") {
                newTurn()
            }
        } message: {
            Text("Wrong!")
        }
        .alert("Correct! I chose \(options[computersChoice])", isPresented: $showCorrect) {
            Button("Okay") {
                score += 1
                newTurn()
            }
        } message: {
            Text("Yeet")
        }
    }
    
    func newTurn() {
        computersChoice = Int.random(in: 0..<3)
        userShouldWin = Bool.random()
    }
    
    func determineOutcome(usersChoice: String) {
        if userShouldWin && usersChoice == winningMoves[computersChoice] {
            showCorrect = true
        } else {
            showWrong = true
        }
        let _ = print(usersChoice)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
