//
//  ContentView-ViewModel.swift
//  DiceRoller
//
//  Created by Radu Petrisel on 01.08.2023.
//

import Foundation

extension ContentView {
    @MainActor final class ViewModel: ObservableObject {
        @Published private(set) var previousRolls = [Int]()
        @Published private(set) var currentRoll = 6
        
        func roll() {
            previousRolls.insert(currentRoll, at: 0)
            currentRoll = Int.random(in: 1...6)
        }
    }
}
