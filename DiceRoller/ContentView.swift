//
//  ContentView.swift
//  DiceRoller
//
//  Created by Radu Petrisel on 01.08.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var roll = Int.random(in: 1...6)
    @State private var previousRolls = [Int]()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Current roll:")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                
                Text("\(roll)")
                    .font(.largeTitle)
                    .padding()
                
                Button("Roll") {
                    roll = Int.random(in: 1...6)
                    previousRolls.append(roll)
                }
                .frame(width: 90, height: 50)
                .background(.blue)
                .foregroundColor(.white)
                .font(.largeTitle)
                .clipShape(Capsule())
                
                List {
                    Section("Previous rolls") {
                        ForEach(previousRolls.indices, id: \.self) { index in
                            Text("\(previousRolls[index])")
                        }
                    }
                }
                .listStyle(.grouped)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
