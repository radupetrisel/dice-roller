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
                
                
                List {
                    Section("Previous rolls") {
                        ForEach(viewModel.previousRolls.indices, id: \.self) { index in
                            Text("\(viewModel.previousRolls[index])")
                        }
                    }
                }
                .listStyle(.grouped)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Previous rolls")
                .accessibilityHint("\(viewModel.previousRolls.map { String($0)}.joined(separator: ", "))")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
