//
//  LocationModel.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172836 on 11/13/20.
//

import Foundation
import CoreData

class LocationMessage {
    
    var location :String
    var message :[String]
    
    init (location:String,message:[String]){
        self.message = message
        self.location = location
    }
}
