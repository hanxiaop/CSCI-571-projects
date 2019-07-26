//
//  TableViewCell.swift
//  homework9
//
//  Created by XIAOPENG HAN on 11/22/18.
//  Copyright © 2018 XIAOPENG HAN. All rights reserved.
//

import UIKit
protocol CellDelegate : class {
    func tapButton(_ tag: Int, _ sender: UIButton)
    
}

class TableViewCell: UITableViewCell {
    
    var cellDelegate: CellDelegate?
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var favouriteImage: UIImageView!
    
    @IBOutlet weak var eventName: UILabel!

    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func chooseFavorite(_ sender: UIButton) {
        cellDelegate?.tapButton(sender.tag, sender)
      
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
