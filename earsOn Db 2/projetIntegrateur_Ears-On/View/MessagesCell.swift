//
//  MessageCell.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172836 on 11/13/20.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    static let id = "MessagesCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(message: String) {
        textLabel?.text = message
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

