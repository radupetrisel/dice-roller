//
//  Roll.swift
//  DiceRoller
//
//  Created by Radu Petrisel on 01.08.2023.
//

import Foundation

struct Roll: Identifiable {
    let id = UUID()
    let value: Int
    let diceType: DiceType
}

enum DiceType: String, CaseIterable {
    case fourSided = "4-Sided"
    case sixSided = "6-Sided"
    case eightSided = "8-Sided"
    case twelveSided = "12-Sided"
    case twentySided = "20-Sided"
    
    var maxValue: Int {
        switch self {
        case .fourSided:
            return 4
        case .sixSided:
            return 6
        case .eightSided:
            return 8
        case .twelveSided:
            return 12
        case .twentySided:
            return 20
        }
    }
}
