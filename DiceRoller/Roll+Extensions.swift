//
//  Roll+Extensions.swift
//  DiceRoller
//
//  Created by Radu Petrisel on 02.08.2023.
//

import Foundation

extension Roll {
    var diceTypeWrapped: DiceType {
        if let diceType = diceType {
            return DiceType(rawValue: diceType)!
        }
        
        return .sixSided
    }
    
    var valuesWrapped: [Int] {
        if let values = values {
            if let intValues = try? JSONDecoder().decode([Int].self, from: values) {
                return intValues
            }
        }
        
        return []
    }
}
