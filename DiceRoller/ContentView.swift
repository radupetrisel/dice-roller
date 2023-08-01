//
//  ContentView.swift
//  DiceRoller
//
//  Created by Radu Petrisel on 01.08.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Current roll:")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    Text("\(viewModel.currentRoll)")
                        .font(.largeTitle)
                        .padding()
                        .animation(.default, value: viewModel.currentRoll)
                    
                    Button("Roll") {
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
                .accessibilityLabel("Roll")
                .accessibilityValue(String(viewModel.currentRoll))
                .accessibilityAction {
                    viewModel.roll()
                }
                
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
                
                
                List {
                    Section("Previous rolls") {
                        ForEach(viewModel.previousRolls) { roll in
                            HStack {
                                Text("\(roll.value)")
                                Spacer()
                                Text(roll.diceType.rawValue)
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
    
    private var previousRollsAccesibilityHint: String {
        viewModel.previousRolls
            .map { "\($0.value) on \($0.diceType.rawValue)" }
            .joined(separator: ", ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
