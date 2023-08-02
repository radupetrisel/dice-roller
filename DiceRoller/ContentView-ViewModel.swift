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
        @Published private(set) var currentRolls = [Int?](repeating: nil, count: 2)
        
        @Published var numberOfDice = 2 {
            willSet {
                if numberOfDice != newValue {
                    saveRolls()
                }
            }
            didSet {
                if numberOfDice != oldValue {
                    resetRolls()
                }
            }
        }
        @Published var diceTypeIndex = 1
        
        var rollTotal: Int {
            currentRollsWrapper.reduce(0) { partialResult, current in
                partialResult + current
            }
        }
        
        var currentDiceType: DiceType {
            diceTypes[diceTypeIndex]
        }
        
        var currentRollsWrapper: [Int] {
            currentRolls.compactMap { $0 }
        }
        
        func roll() {
            saveRolls()
            currentRolls.removeAll()
            
            for _ in 0..<numberOfDice {
                currentRolls.append(Int.random(in: 1...currentDiceType.maxValue))
            }
        }
        
        func moveToNextDiceType() {
            diceTypeIndex = min(diceTypeIndex + 1, diceTypes.count - 1)
        }
        
        func moveToPreviousDiceType() {
            diceTypeIndex = max(diceTypeIndex - 1, 0)
        }
        
        func resetRolls() {
            currentRolls = [Int?](repeating: nil, count: numberOfDice)
        }
        
        func incrementNumberOfDice() {
            numberOfDice = min(numberOfDice + 1, 3)
        }
        
        func decrementNumberOfDice() {
            numberOfDice = max(numberOfDice - 1, 1)
        }
        
        private func saveRolls() {
            if currentRollsWrapper.count == numberOfDice {
                let newRoll = Roll(values: currentRollsWrapper, diceType: currentDiceType)
                previousRolls.insert(newRoll, at: 0)
            }
        }
    }
}
