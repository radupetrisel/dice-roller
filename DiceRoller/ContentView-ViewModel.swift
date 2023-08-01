//
//  ContentView-ViewModel.swift
//  DiceRoller
//
//  Created by Radu Petrisel on 01.08.2023.
//

import Foundation

extension ContentView {
    @MainActor final class ViewModel: ObservableObject {
        let diceTypes = DiceType.allCases
        
        @Published private(set) var previousRolls = [Roll]()
        @Published private(set) var currentRoll = 6
        
        @Published var diceTypeIndex = 1
        
        var currentDiceType: DiceType {
            diceTypes[diceTypeIndex]
        }
        
        func roll() {
            let newRoll = Roll(value: currentRoll, diceType: currentDiceType)
            previousRolls.insert(newRoll, at: 0)
            currentRoll = Int.random(in: 1...currentDiceType.maxValue)
        }
        
        func moveToNextDiceType() {
            diceTypeIndex = min(diceTypeIndex + 1, diceTypes.count - 1)
        }
        
        func moveToPreviousDiceType() {
            diceTypeIndex = max(diceTypeIndex - 1, 0)
        }
    }
}
