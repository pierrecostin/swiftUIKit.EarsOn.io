//
//  FormulaireViewController.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172954 on 11/5/20.
//

import Foundation
import UIKit
import CoreData

class AddMessagesViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    var locations : [Location] = []
    var messages: [[FrequentMessages]] = []
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var buttonSupprimer: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locations = Location.all
        dismissKeyboard()
       
        // buttonSupprimer(buttonSupprimer)
        // categoryPicker.reloadAllComponents()
    }
    
    
    @IBAction func buttonSupprimer(_ sender: UIButton) {
        let index = categoryPicker.selectedRow(inComponent: 0)
        let locationToDelete = locations[index]
        AppDelegate.viewContext.delete(locationToDelete)
        try? AppDelegate.viewContext.save()
        categoryPicker.reloadAllComponents()
    
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row].name
    }
    
    @IBAction func save() {
     guard let message = messageTextField.text else {
        return
        }
        if messageTextField.text == "" {
            presentAlert(with: "Oups vous n'avez pas entrez un message ")
        }else{
     let messages = FrequentMessages(context:AppDelegate.viewContext )
        messages.message = message
        messages.location = getSelectedLocation()
        do {
           try AppDelegate.viewContext.save()
            presentAlert(with: "Save successfully")
        } catch {
            presentAlert(with: "Saving data failed")
        }
    }
    }
     
    private func getSelectedLocation() -> Location?{
        if locations.count > 0{
            let index = categoryPicker.selectedRow(inComponent: 0)
            return locations[index]
        }
        return nil
    }
    
    
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "Notification", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    internal func textFieldShouldReturn(_ txtView: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
       }
    
    @objc func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
        view.endEditing(true)
    }
    
   
}
