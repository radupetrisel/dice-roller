//
//  ContentView.swift
//  DiceRoller
//
//  Created by Radu Petrisel on 01.08.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    @State private var feedbackGenerator = UINotificationFeedbackGenerator()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Current roll")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        ForEach(viewModel.currentRolls.indices, id: \.self) {
                            Text(getRollDisplayText(viewModel.currentRolls[$0]))
                                .font(.largeTitle)
                                .padding()
                                .animation(.default, value: viewModel.currentRolls[$0])
                        }
                    }
                    
                    Text("Total")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    Text(String(viewModel.rollTotal))
                        .font(.largeTitle)
                        .padding()
                        .animation(.default, value: viewModel.rollTotal)
                    
                    Button("Roll") {
                        feedbackGenerator.notificationOccurred(.success)
                        viewModel.roll()
                    }
                    .frame(width: 90, height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .clipShape(Capsule())
                }
                .accessibilityElement(children: .ignore)
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel(viewModel.currentRollsWrapper.isEmpty ? "Roll" : "")
                .accessibilityValue(viewModel.currentRollsWrapper.isEmpty ? "" : currentRollAccesibilityValue)
                .accessibilityAction {
                    viewModel.roll()
                }
                
                HStack {
                    Picker("Select dice type", selection: $viewModel.diceTypeIndex) {
                        ForEach(viewModel.diceTypes.indices, id: \.self) {
                            Text(viewModel.diceTypes[$0].rawValue)
                                .tag($0)
                        }
                    }
                    .accessibilityAdjustableAction { direction in
                        if direction == .increment {
                            viewModel.moveToNextDiceType()
                        } else if direction == .decrement {
                            viewModel.moveToPreviousDiceType()
                        }
                    }
                    .accessibilityValue("\(viewModel.currentDiceType.rawValue)")
                    
                    Picker("Select number of dice", selection: $viewModel.numberOfDice) {
                        ForEach(1..<4, id: \.self) {
                            Text("\($0) \($0 == 1 ? "die" : "dice")")
                        }
                    }
                    .accessibilityAdjustableAction { direction in
                        if direction == .increment {
                            viewModel.incrementNumberOfDice()
                        } else if direction == .decrement {
                            viewModel.decrementNumberOfDice()
                        }
                    }
                    .accessibilityValue("\(viewModel.numberOfDice)")
                }
                
                List {
                    Section("Previous rolls") {
                        ForEach(viewModel.previousRolls) { roll in
                            HStack {
                                Text("\(getRollsString(roll.valuesWrapped))")
                                Spacer()
                                Text(roll.diceTypeWrapped.rawValue)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.grouped)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Previous rolls")
                .accessibilityHint(previousRollsAccesibilityHint)
            }
        }
    }
    
    private var currentRollAccesibilityValue: String {
        "Rolled: \(getRollsString(viewModel.currentRollsWrapper)). Total: \(viewModel.rollTotal)"
    }
    
    private var previousRollsAccesibilityHint: String {
        viewModel.previousRolls
            .map { "\(getRollsString($0.valuesWrapped)) on \($0.diceTypeWrapped.rawValue)" }
            .joined(separator: ", ")
    }
    
    private func getRollsString(_ rolls: [Int]) -> String {
        rolls.map { String($0) }
            .joined(separator: ", ")
    }
    
    private func getRollDisplayText(_ roll: Int?) -> String {
        guard let roll = roll else { return "???" }
        
        return String(roll)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
