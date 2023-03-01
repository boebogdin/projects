//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Boe Bogdin on 1/11/23.
//

import SwiftUI



struct ContentView: View {
    @State private var showingScore = false
    @State private var showingEndScene = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var usersScore = 0
    @State private var questionsAsked = 0
    
//    @State private var stuff = 0.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()


            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.white)
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.ultraLight))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            //flag was tapped
                            flagTapped(number)
//                            stuff+=360
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
//                                .rotation3DEffect(.degrees(stuff), axis: (x: 0, y: 1, z: 0))
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(usersScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert("Game over!", isPresented: $showingEndScene) {
            Button("Reset", action: resetGame)
        } message: {
            Text("Your final score was \(usersScore) out of 8.")
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(usersScore)")
        }
        
        
    }
    
    func flagTapped(_ number: Int) {
        questionsAsked += 1
        if number == correctAnswer {
            scoreTitle = "Correct"
            usersScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        showingScore = true
        
        if questionsAsked == 8 {
            showingEndScene = true
        }
        
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        askQuestion()
        usersScore = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
