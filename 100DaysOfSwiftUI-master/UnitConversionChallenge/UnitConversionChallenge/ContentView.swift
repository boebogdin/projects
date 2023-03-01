//
//  ContentView.swift
//  UnitConversionChallenge
//
//  Created by Boe Bogdin on 1/10/23.
//

import SwiftUI

struct ContentView: View {
    @State var startUnit = 0
    @State var endUnit = 1
    @State var userInput = ""
    
    var pluralStartConversionUnit: String {
        switch units[startUnit] {
        case "m":
            return "meters"
        case "km":
            return "kilometers"
        case "ft":
            return "feet"
        case "yd":
            return "yards"
        case "mi":
            return "miles"
        default:
            return "Meters"
        }
    }
    
    var pluralEndConversionUnit: String {
        switch units[endUnit] {
        case "m":
            return "meters"
        case "km":
            return "kilometers"
        case "ft":
            return "feet"
        case "yd":
            return "yards"
        case "mi":
            return "miles"
        default:
            return "Meters"
        }
    }
    
    var convertedInput: Double {
        let userInputDouble = Double(userInput) ?? 0
        var userInputInMeters = 0.0
        var userInputConverted = 0.0
        
        switch units[startUnit] {
        case "m":
            userInputInMeters = userInputDouble
        case "km":
            userInputInMeters = userInputDouble * 1000
        case "ft":
            userInputInMeters = userInputDouble / 3.281
        case "yd":
            userInputInMeters = userInputDouble / 1.094
        case "mi":
            userInputInMeters = userInputDouble * 1609.34
        default:
            userInputInMeters = 0
        }
        
        switch units[endUnit] {
        case "m":
            userInputConverted = userInputInMeters
        case "km":
            userInputConverted = userInputInMeters / 1000
        case "ft":
            userInputConverted = userInputInMeters * 3.281
        case "yd":
            userInputConverted = userInputInMeters * 1.094
        case "mi":
            userInputConverted = userInputInMeters / 1609.34
        default:
            userInputConverted = 0
        }

        return userInputConverted
    }
    
    let units = ["m", "km", "ft", "yd", "mi"]
    var body: some View {
        Form {
            
            Section(content: {
                Picker("Start Unit", selection: $startUnit) {
                    ForEach(0 ..< units.count) {
                        Text("\(self.units[$0])")
                    }
                }
                    .pickerStyle(SegmentedPickerStyle())
                
                Picker("Ending Units", selection: $endUnit) {
                    ForEach(0 ..< units.count) {
                        Text("\(self.units[$0])")
                    }
                }
                    .pickerStyle(SegmentedPickerStyle())
                
                TextField("Enter number of \(pluralStartConversionUnit)", text: $userInput)
                    .keyboardType(.decimalPad)
            }, header: {
                Text("Convert From/Convert To")
            })
            
            Section(content: {
                Text("\(convertedInput.formatted()) \(pluralEndConversionUnit)")
                    .padding()
            }, header: {
                Text("Result")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
