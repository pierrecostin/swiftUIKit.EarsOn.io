//
//  talkingViewController.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172954 on 11/1/20.
//

import Foundation
import UIKit
import Speech
import AVFoundation

class talkingViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var talkingButton: UIButton!
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      talk(talkingButton)
      dismissKeyboard()
       
}
    
    @objc func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
        view.endEditing(true)
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func talk(_ sender: UIButton) {
       
        if textField.text != nil {
            myUtterance = AVSpeechUtterance(string: "\(textField.text!)")
            myUtterance.rate = 0.5
            synth.speak(myUtterance)
        }
    }
    
    
    
    
}
