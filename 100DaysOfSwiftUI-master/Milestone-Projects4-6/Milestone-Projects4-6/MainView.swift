//
//  ContentView.swift
//  Milestone-Projects4-6
//
//  Created by Boe Bogdin on 1/18/2023
//

import SwiftUI

class SettingsToggle: ObservableObject {
    @Published var isSettingsDisplayed = true
}

struct MainView: View {
    @ObservedObject var settings = Settings()
    @ObservedObject var settingsToggle = SettingsToggle()

    var body: some View {
        NavigationView {
            Group {
                if settingsToggle.isSettingsDisplayed {
                    SettingsView(settings: settings, settingsToggle: settingsToggle)
                }
                else {
                    GameView(settings: settings, settingsToggle: settingsToggle)
                }
            }
            .navigationBarTitle("Multiplication")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().colorScheme(.dark)
    }
}
