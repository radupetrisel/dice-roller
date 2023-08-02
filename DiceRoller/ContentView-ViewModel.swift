//
//  ContentView-ViewModel.swift
//  DiceRoller
//
//  Created by Radu Petrisel on 01.08.2023.
//

import Foundation

extension ContentView {
    @MainActor final class ViewModel: ObservableObject {
        private let dataController = DataController()
        private let jsonEncoder = JSONEncoder()
        
        let diceTypes = DiceType.allCases
        
        @Published private(set) var previousRolls: [Roll]
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
        
        init() {
            do {
                let fetchRequest = Roll.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Roll.date, ascending: false)]
                previousRolls = try dataController.viewContext.fetch(fetchRequest)
            } catch {
                previousRolls = []
            }
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
                let newRoll = makeRoll()
                previousRolls.insert(newRoll, at: 0)
                do {
                    try dataController.viewContext.save()
                } catch {
                    print("Error saving rolls: \(error.localizedDescription)")
                }
            }
        }
        
        private func makeRoll() -> Roll {
            let roll = Roll(context: dataController.viewContext)
            roll.id = UUID()
            roll.diceType = currentDiceType.rawValue
            roll.values = try? jsonEncoder.encode(currentRollsWrapper)
            roll.date = Date.now
            
            return roll
        }
    }
}
