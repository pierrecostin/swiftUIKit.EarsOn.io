//
//  SettingsViewController.swift
//  projetIntegrateur_Ears-On
//
//  Created by PIERRE COSTIN on 2020-11-21.
//

//French (Canada) - fr-CA
//French (France) - fr-FR

//English (Australia) - en-AU
//English (Ireland) - en-IE
//English (South Africa) - en-ZA
//English (United Kingdom) - en-GB
//English (United States) - en-US

//German (Germany) - de-DE

import Foundation
import UIKit

enum Language: String, CaseIterable {
    case frenchCanada = "fr-CA",
         frenchFrance = "fr-FR",
         englishAustralia = "en-AU",
         englishUnitedStates = "en-US",
         englishUnitedKingdom = "en-GB",
         germanGermany = "de-DE"
    
    var locale: Locale {
        return Locale(identifier: self.rawValue)
    }
    
    var displayName: String {
        return (locale as NSLocale).displayName(forKey: .identifier, value: rawValue) ?? "Undefined"
    }
    
    static func index(of language: Language) -> Int {
        return allCases.firstIndex(of: language)!
    }
    
    static func language(atIndex index: Int) -> Language {
        return allCases[index]
    }
    
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var SpeakLanguagePicker: UIPickerView!
    @IBOutlet weak var ListenLanguagePicker: UIPickerView!
    
    
    
    
    @IBOutlet weak var SaveChangesButton: UIButton!
    
    //UserDefaults.standard.set("mynameisben", forKey: "language")
    
    
    override func viewDidLoad() {
        
        SaveChangesButton.layer.cornerRadius = 25.0
        
        loadUserSettings()
    }
    
    func loadUserSettings() {
        loadSetting(fromKey: .hearLanguage, toPicker: ListenLanguagePicker)
        loadSetting(fromKey: .speakLanguage, toPicker: SpeakLanguagePicker)
    }
    
    
    func loadSetting(fromKey key: UserDefaults.Key, toPicker picker: UIPickerView) {
        if let identifier = UserDefaults.string(forKey: key),
           let language = Language(rawValue: identifier) {
            let row = Language.index(of: language)
            picker.selectRow(row, inComponent: 0, animated: false)
        }
    }
    
    
    
    @IBAction func SettingButtonTapped(_ sender: Any) {
        saveSetting(fromPicker: ListenLanguagePicker, forKey: .hearLanguage)
        saveSetting(fromPicker: SpeakLanguagePicker, forKey: .speakLanguage)
        
        presentOKAlert(message: "Réglages sauvegardés")
    }
    
    func saveSetting(fromPicker picker: UIPickerView, forKey key: UserDefaults.Key) {
        let index = picker.selectedRow(inComponent: 0)
        let languageCode = Language.language(atIndex: index).rawValue
        UserDefaults.set(languageCode, forKey: key)
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Language.allCases.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Language.allCases[row].displayName
    }
    
    
    @objc func presentOKAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}






























/*

extension UIViewController {
    
    func presentOKAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}*/
