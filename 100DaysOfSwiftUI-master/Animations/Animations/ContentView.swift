//
//  ContentView.swift
//  Animations
//
//  Created by Boe Bogdin on 1/17/23.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 1.0
    @State private var enabled = false
    
    var body: some View {
        print(animationAmount)
        return VStack {
//            Button("Tap Me") {
//                animationAmount += 1
//            }
//            .padding(50)
//            .background(.red)
//            .foregroundColor(.white)
//            .clipShape(Circle())
//            //        .scaleEffect(animationAmount)
//            //        .blur(radius: (animationAmount - 1) * 3)
//            .overlay(
//                Circle()
//                    .stroke(.red)
//                    .scaleEffect(animationAmount)
//                    .opacity(2 - animationAmount)
//                    .animation(
//                        .easeOut(duration: 1)
//                            .repeatForever(autoreverses: false),
//                        value: animationAmount
//                    )
//            )
//            .onAppear(perform: {
//                animationAmount = 2
//            })
//            .animation(.easeInOut(duration: 2), value: animationAmount)
            
            
            
            
            
            
//            VStack {
//                Stepper("Scale amount", value: $animationAmount.animation(
//                    .easeInOut(duration: 1)
//                            .repeatCount(3, autoreverses: true)
//                ), in: 1...10)
//
//                Spacer()
//
//                Button("Tap Me") {
//                    animationAmount += 1
//                }
//                .padding(40)
//                .background(.red)
//                .foregroundColor(.white)
//                .clipShape(Circle())
//                .scaleEffect(animationAmount)
//            }
            
            
            
//            Button("Tap Me") {
//                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
//                    animationAmount += 360
//                }
//            }
//            .padding(50)
//            .background(.red)
//            .foregroundColor(.white)
//            .clipShape(Circle())
//            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
            
            
            
            
            Button("Tap Me") {
                enabled.toggle()
            }
            .frame(width: 200, height: 200)
            .background(enabled ? .blue : .red)
            .animation(.default, value: enabled)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
