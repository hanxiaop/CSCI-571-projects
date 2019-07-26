//
//  EventViewController.swift
//  homework9
//
//  Created by XIAOPENG HAN on 11/23/18.
//  Copyright © 2018 XIAOPENG HAN. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var getModelFromTable: EventTab?
    
    
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var venue: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var priceRange: UILabel!
    @IBOutlet weak var ticketStatus: UILabel!
    
    
    
    @IBAction func buyTicket(_ sender: Any) {
        let tickURL = getModelFromTable?.buyTicketAt
        UIApplication.shared.open(URL(string: tickURL!)! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func showSeatMap(_ sender: Any) {
        let seatMap = getModelFromTable?.seatMap
        if (seatMap != nil) {
            UIApplication.shared.open(URL(string: seatMap!)! as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(getModelFromTable!)
        
        var strName = ""
        for names in (getModelFromTable?.artOrTeamNames)! {
            strName += names + " | "
        }
        let substring = String(strName.dropLast(3))
        artist.text = substring
        venue.text = getModelFromTable?.veneName
        time.text = getModelFromTable?.date
        category.text = getModelFromTable?.eventTypeCategory
        priceRange.text = getModelFromTable?.priceRange
        ticketStatus.text = getModelFromTable?.ticketStatus
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
