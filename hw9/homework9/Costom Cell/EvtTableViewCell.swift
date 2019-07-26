//
//  EvtTableViewCell.swift
//  homework9
//
//  Created by XIAOPENG HAN on 11/25/18.
//  Copyright © 2018 XIAOPENG HAN. All rights reserved.
//

import UIKit

class EvtTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var theButton: UIButton!
    
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var dateDisplay: UILabel!
    
    @IBOutlet weak var typeText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
