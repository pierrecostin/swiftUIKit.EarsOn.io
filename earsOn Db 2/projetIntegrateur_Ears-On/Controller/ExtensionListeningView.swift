//
//  ExtensionListeningView.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172836 on 11/13/20.
//

import UIKit


extension listeningViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath)

        let message = messages[indexPath.section][indexPath.row]
        cell.textLabel?.text = message.message
              
           
           return cell
       }
    
func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
    guard let location = messages[section].first?.location, let  name = location.name else {
            return nil
        }
      return name
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let msgToDelete = messages[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            AppDelegate.viewContext.delete(msgToDelete)
            try? AppDelegate.viewContext.save()
            tableView.endUpdates()
           }
            
        }
    }

