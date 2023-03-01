//
//  ContentView.swift
//  WeSplit
//
//  Created by Boe Bogdin on 1/9/23.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    let tipPercentages = [10, 15, 20, 25, 0]
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
//        let tipSelection = Double(tipPercentages[tipPercentage])
        let tipSelection = Double(tipPercentage)
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var checkPlusTip: Double {
//        let tipSelection = Double(tipPercentages[tipPercentage])
        let tipSelection = Double(tipPercentage)
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        
        return grandTotal
    }
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
//                        ForEach(0 ..< tipPercentages.count) {
                        ForEach(0 ..< 101) {
//                            Text("\(self.tipPercentages[$0])%")
                            Text("\($0)%")
                        }
                    }
//                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Check Total")) {
                    Text("$\(checkPlusTip, specifier: "%.2f")")
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                
            }
            .navigationBarTitle("WeSplit")
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        Below is some examples of code.
        
        //This was outside the body
        //let students = ["Harry", "Hermione", "Ron"]
        //    @State private var selectedStudent = 0
        //    @State var tapCount = 0
        //    @State var name = ""
//
//        NavigationView {
//            Form {
//                Section {
//                    Text("Hello World")
//                }
////                Using the dollar sign before a variable name means to allow two way binding. The variable can be read and can be written to
//                TextField("Enter your name", text: $name)
//                Text("Hello \(name)")
//            }
//            .navigationBarTitle("SwiftUI")
////            Here is a different type of title
////            .navigationBarTitle(Text("SwiftUI"), displayMode: .inline)
//        }
//        VStack {
//            Picker("Select your student", selection: $selectedStudent) {
//                ForEach(0 ..< students.count) {
//                    Text(self.students[$0])
//                }
//            }
//        }
//
//        Button("Tap count: \(tapCount)") {
//            self.tapCount += 1
//        }
//        Form {
////            Groups are like <></>
////            They are containers that don't actually do anything
////            They are needed because swiftUI only allows 10 children per parent. If we group items together then that group is seen as the child and not what is inside of it.
//            Group {
//                Text("Hello World")
//                Text("Hello World")
//                Text("Hello World")
//                Text("Hello World")
//            }
////            Section is like Group but will actually split up the contents. Kind of like a div
//            Section {
//                Text("Hello World")
//                Text("Hello World")
//                Text("Hello World")
//                Text("Hello World")
//                Text("Hello World")
//                Text("Hello World")
//            }
//
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}
