//
//  UpcomingEventController.swift
//  homework9
//
//  Created by XIAOPENG HAN on 11/25/18.
//  Copyright © 2018 XIAOPENG HAN. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire



class UpcomingEventController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventCellDelegate {
    
    
    
    var eventsArray = [UpcomingModel]()
    var keepDefault = [UpcomingModel]()
    
    var getEventModel: EventTab?
    
    var sort: String = "Default"
    var order: String = "Ascending"
    
    let cloudUrl = "http://hw8proj-env-1.rj7bsmp3zx.us-east-2.elasticbeanstalk.com/apiRequest?"
    
    var resultJSON: JSON?
   
    @IBOutlet weak var noResultsDisplay: UIView!
    
    
    @IBOutlet weak var sortSegment: UISegmentedControl!
    @IBOutlet weak var orderSegment: UISegmentedControl!
    
    @IBAction func sortSeg(_ sender: Any) {
        let sortIndex = sortSegment.selectedSegmentIndex
        let sortTitle = sortSegment.titleForSegment(at: sortIndex)
        self.sort = sortTitle!
        checkOrder(sort: self.sort, order: self.order)
    }
    @IBAction func ascendingSeg(_ sender: Any) {
        let orderIndex = orderSegment.selectedSegmentIndex
        let orderTitle = orderSegment.titleForSegment(at: orderIndex)

        self.order = orderTitle!
        checkOrder(sort: self.sort, order: self.order)
    }
    
    
    
    
    func checkOrder(sort: String, order: String) {
        if (sort == "Default") {
            orderSegment.isUserInteractionEnabled = false
            orderSegment.tintColor = UIColor.rgb(red: 141, green: 189, blue: 249)
            eventsArray = keepDefault
        } else {
            orderSegment.isUserInteractionEnabled = true
            orderSegment.tintColor = UIColor.rgb(red: 0, green: 122, blue: 255)
            if sort == "Name" {
                if (order == "Ascending") {
                    eventsArray = eventsArray.sorted(by: {$0.eventNmae < $1.eventNmae})
                    
                } else {
                    eventsArray = eventsArray.sorted(by: {$0.eventNmae > $1.eventNmae})
                }
            }
            if sort == "Time" {
                if (order == "Ascending") {
                    eventsArray = eventsArray.sorted(by: {$0.date < $1.date})
                    
                } else {
                    eventsArray = eventsArray.sorted(by: {$0.date > $1.date})
                    
                }
            }
            if sort == "Artist" {
                if (order == "Ascending") {
                    
                    eventsArray = eventsArray.sorted(by: {$0.player < $1.player})
                } else {
                    
                    eventsArray = eventsArray.sorted(by: {$0.player > $1.player})
                }
            }
            if sort == "Type" {
                if (order == "Ascending") {
                    eventsArray = eventsArray.sorted(by: {$0.type < $1.type})
                    
                } else {
                    
                    eventsArray = eventsArray.sorted(by: {$0.type > $1.type})
                }
            }
            
            
        }
        DispatchQueue.main.async(execute: self.evtTable.reloadData)
        
        
    }
    
    
    
    
    
    @IBOutlet var evtTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        orderSegment.isUserInteractionEnabled = false
        orderSegment.tintColor = UIColor.rgb(red: 141, green: 189, blue: 249)
        
        //self.evtTable.register(EvtTableViewCell.self, forCellReuseIdentifier: "eventCellPro")
        evtTable.delegate = self
        evtTable.dataSource = self
        evtTable.rowHeight = 120
        self.evtTable.tableFooterView = UIView()
        self.evtTable.register(UINib(nibName: "EventTableCellTableViewCell", bundle: nil), forCellReuseIdentifier: "eventCell")
        SwiftSpinner.show("Searching for upcoming events...")
       
        let formattedVenue = getEventModel?.veneName.replacingOccurrences(of: " ", with: "+")
        let requestURL = cloudUrl + "songkickReq=\(formattedVenue!)"
        
        Alamofire.request(requestURL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON = JSON(response.result.value!)
                self.resultJSON = responseJSON
                
                self.useJSONfile()
                
                DispatchQueue.main.async(execute: self.evtTable.reloadData)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func useJSONfile() {
        if self.resultJSON != nil {
            //print(self.resultJSON!)
            if let eventResults = resultJSON!["resultsPage"]["results"]["event"].array {
                if (eventResults.count > 0) {
                    if (eventResults.count > 4) {
                        var i = 0
                        for event in eventResults {
                            let tempModel = UpcomingModel()
                            if i < 5 {
                                tempModel.eventLink = event["uri"].stringValue
                                tempModel.date = event["start"]["date"].stringValue
                                tempModel.time = event["start"]["time"].stringValue
                                tempModel.eventNmae = event["displayName"].stringValue
                                tempModel.player = event["performance"][0]["displayName"].stringValue
                                tempModel.type = event["type"].stringValue
                                
                            } else {
                                break
                            }
                            i += 1
                            eventsArray.append(tempModel)
                            keepDefault.append(tempModel)
                        }
                        
                        
                        
                    } else {
                        let tempModel = UpcomingModel()
                       
                        for event in eventResults {
                            tempModel.eventLink = event["uri"].stringValue
                            tempModel.date = event["start"]["date"].stringValue
                            tempModel.time = event["start"]["time"].stringValue
                            tempModel.eventNmae = event["displayName"].stringValue
                            tempModel.player = event["performance"][0]["displayName"].stringValue
                            tempModel.type = event["type"].stringValue
                        }
                        eventsArray.append(tempModel)
                        keepDefault.append(tempModel)
                    }
                    
                    
                }
                
                
            } else {
                self.evtTable.backgroundView = noResultsDisplay
                self.evtTable.tableFooterView = UIView()
                
                
            }
            
            
            
            SwiftSpinner.hide()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableCellTableViewCell = self.evtTable.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)  as! EventTableCellTableViewCell
        //cell = self.eventsTable.dequeueReusableCell(withIdentifier: "eventCellPro", for: indexPath)
        
        cell.eventCellDelegate = self

        cell.eventNameButton.tag = indexPath.row
        cell.eventNameButton.setTitle(self.eventsArray[indexPath.row].eventNmae, for: .normal)
        cell.artistName.text = eventsArray[indexPath.row].player
        let dateTime = eventsArray[indexPath.row].date + " " + eventsArray[indexPath.row].time

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterConverted = DateFormatter()
        dateFormatterConverted.dateFormat = "MMM dd,yyyy HH:mm:ss"

        if let date = dateFormatter.date(from: dateTime) {
            cell.dateAndTime.text = dateFormatterConverted.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        cell.typeOfEvent.text = "Type: \(eventsArray[indexPath.row].type)"


        return cell

    }
    
    
    func tapButtonE(_ tag: Int, _ sender: UIButton) {
        let tickURL = self.eventsArray[tag].eventLink

        UIApplication.shared.open(URL(string: tickURL)! as URL, options: [:], completionHandler: nil)

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


