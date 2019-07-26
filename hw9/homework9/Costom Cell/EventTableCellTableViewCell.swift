//
//  EventTableCellTableViewCell.swift
//  homework9
//
//  Created by XIAOPENG HAN on 11/25/18.
//  Copyright © 2018 XIAOPENG HAN. All rights reserved.
//

import UIKit

protocol EventCellDelegate : class {
    func tapButtonE(_ tag: Int, _ sender: UIButton)
    
}


class EventTableCellTableViewCell: UITableViewCell {

    var eventCellDelegate: EventCellDelegate?
    
    
    @IBOutlet weak var eventNameButton: UIButton!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var typeOfEvent: UILabel!
    
    
    @IBAction func tapEventButton(_ sender: UIButton) {
        eventCellDelegate?.tapButtonE(sender.tag, sender)
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
