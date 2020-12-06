//
//  Location.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172954 on 11/3/20.
//

import Foundation
import CoreData

class Location: NSManagedObject {
    static var all:[Location]{
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        guard let locations = try? AppDelegate.viewContext.fetch(request) else {
            return[]
        }
        return locations
    }
    
    static func deleteAll() {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        guard let locations = try? AppDelegate.viewContext.fetch(request) else {
            return
        }
        
        for location in locations {
            AppDelegate.viewContext.delete(location)
        }
        try? AppDelegate.viewContext.save()

    }
    
}



