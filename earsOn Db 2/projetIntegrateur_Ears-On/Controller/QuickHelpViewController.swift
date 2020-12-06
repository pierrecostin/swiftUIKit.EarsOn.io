//
//  QuickHelpViewController.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172954 on 11/3/20.
//

import Foundation
import UIKit
import CoreData
import Speech
import AVFoundation


class quickHelpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var locations = Location.all
    var messages = FrequentMessages.all
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var ajoutMessageLabel: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        locations = Location.all
        messages = FrequentMessages.all
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
        return locations.count
    }
        return messages[component].count
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
        return locations[row].name
    }
        return messages[row].first?.message
    }
    
   @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
   @IBAction func playMessage() {
        myUtterance = AVSpeechUtterance(string: "\(pickerView.selectedRow(inComponent: 1))")
        myUtterance.rate = 0.5
        synth.speak(myUtterance)
    }
    
    @IBAction func delateMessage() {
        let msgToDelete = FrequentMessages(context:AppDelegate.viewContext )
        let index = pickerView.selectedRow(inComponent: 1)
        msgToDelete.message = messages[index].first?.message
        
        AppDelegate.viewContext.delete(msgToDelete)
        do {
                try AppDelegate.viewContext.save()
                presentAlert(with: "Delete successfully")
              } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        
        pickerView.reloadAllComponents()
    }
    
    private func defaultData(){
        
       
        let defaultLocations = ["Pharmacie","Taxi","Restaurant"]
        let defaultMessages = ["Est-ce que je peux avoir ce medicament svp",
                                   "Amenez moi a laerport svp",
                                   "Le menu svp "]
        
        
        for defaultLocation in defaultLocations {
            let location = Location(context:AppDelegate.viewContext )
            location.setValue(defaultLocation, forKey: "name") // not keyPath
            locations.append(location)
            
        }
        
        for defaultMessage in defaultMessages {
            let message = FrequentMessages(context:AppDelegate.viewContext )
            message.setValue(defaultMessage, forKey: "message") // not keyPath
            messages.append([message])
            message.location = Location(context:AppDelegate.viewContext )
        
        }
        
        do {
                try AppDelegate.viewContext.save()
              } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "Notification", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
