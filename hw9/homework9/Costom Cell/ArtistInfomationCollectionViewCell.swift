//
//  ArtistInfomationCollectionViewCell.swift
//  homework9
//
//  Created by XIAOPENG HAN on 11/26/18.
//  Copyright © 2018 XIAOPENG HAN. All rights reserved.
//

import UIKit
protocol ButtonDelegate : class {
    func tapButton(_ tag: Int, _ sender: UIButton)
    
}


class ArtistInfomationCollectionViewCell: UICollectionViewCell {
    
    var buttonDelegate: ButtonDelegate?
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistFollowers: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var spotifyButton: UIButton!
    
    
    @IBAction func clickToSpotify(_ sender: UIButton) {
        //UIApplication.shared.open(URL(string: )! as URL, options: [:], completionHandler: nil)
        buttonDelegate?.tapButton(sender.tag, sender)
    }
    
}
