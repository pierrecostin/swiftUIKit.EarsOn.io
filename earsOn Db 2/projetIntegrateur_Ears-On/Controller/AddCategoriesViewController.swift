//
//  AddCategoriesViewController.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172954 on 11/19/20.
//

import Foundation
import UIKit
import CoreData

class AddCategoriesViewController: UIViewController {
   
    var locations = Location.all
 
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var categotyMessageLabel: UITextField!

   fileprivate func displayCtegoryList() {
        var categ = ""
        for location in Location.all {
            if let name = location.name{
                categ += name + "\n"
            }
        }
        textView.text = categ
    }
    
    @IBAction func clearTextView(_ sender: Any) {
        textView.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locations = Location.all
        displayCtegoryList()
        dismissKeyboard()
        
        textView.layer.cornerRadius=20.0
    }
}
    
    extension AddCategoriesViewController : UITextFieldDelegate {
        func textFieldShouldReturn(_ categoryMessageLabel: UITextField) -> Bool {
                categoryMessageLabel.resignFirstResponder()
                addCategory()
                return true
               }
        
   func addCategory() {
        guard let locationName = categotyMessageLabel.text, var categories = textView.text
        else {
            return
        }
        categories += locationName+"\n"
        textView.text = categories
        categotyMessageLabel.text = ""
        saveLocations(named: locationName)
        
    }
    
    private func saveLocations(named name: String){
        let loc = Location(context: AppDelegate.viewContext)
        loc.name = name
    do {
       try AppDelegate.viewContext.save()
        presentAlert(with: "Save successfully")
    } catch {
        presentAlert(with: "Saving data failed")
    }
    }
    
    
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "Notification", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   @objc func dismissKeyboard() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
            view.endEditing(true)
        }

    
}
    

