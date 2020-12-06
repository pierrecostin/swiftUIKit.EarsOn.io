//
//  FrequentMessages.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172954 on 11/3/20.
//

import Foundation
import CoreData

class FrequentMessages: NSManagedObject {
    static var all:[[FrequentMessages]]{
        let request: NSFetchRequest<FrequentMessages> = FrequentMessages.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "location.name", ascending: true),
            NSSortDescriptor(key: "message", ascending: true),
        ]
        //request.predicate = NSPredicate(format: "location.name == %@", "Pharmacie")
                
        guard let messages = try? AppDelegate.viewContext.fetch(request) else {
            return[]
        }
        return messages.convertedToArrayOfArray
        }
}

extension Array where Element == FrequentMessages {
    var convertedToArrayOfArray: [[FrequentMessages]] {
        var dict = [Location: [FrequentMessages]]()

        for message in self where message.location != nil {
            dict[message.location!, default: []].append(message)
        }

        var result = [[FrequentMessages]]()
        for (_, val) in dict {
            result.append(val)
        }

        return result
    }
}


