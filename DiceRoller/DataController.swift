//
//  DataController.swift
//  DiceRoller
//
//  Created by Radu Petrisel on 02.08.2023.
//

import CoreData
import Foundation

final class DataController {
    private static let containerName = "DiceRoller"
    
    private let container = NSPersistentContainer(name: DataController.containerName)
    let viewContext: NSManagedObjectContext
    
    init() {
        viewContext = container.viewContext
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Could not load CoreData persistent stores: \(error.localizedDescription)")
            }
        }
    }
}
