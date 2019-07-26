//
//  TableViewController.swift
//  homework9
//
//  Created by XIAOPENG HAN on 11/22/18.
//  Copyright © 2018 XIAOPENG HAN. All rights reserved.
//

import UIKit
import SwiftyJSON
import EasyToast

class TableViewController: UITableViewController, CellDelegate {

    
    var eventsArray = [AnEvent]()
    var eventsArray2 = [AnEvent]()
    var passJSON :JSON?
    var allDataArray = [EventTab]()
    var theEventTabModel: EventTab?
    
    var storedEventsArray = [AnEvent]()
    var storedAllDataArray = [EventTab]()
    var favoriteEventsArray = [AnEvent]()
    var favoriteAllDataArray = [EventTab]()
    
    let defaults = UserDefaults.standard
    
    var favoriteEvent: [String: Any] = [:]
    var favoriteTab: [String: Any] = [:]
    var tabBarNavigation: UINavigationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(passJSON!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        configureTablieView()
        
        
//        if defaults.array(forKey: "anEvent") != nil {
//            self.favoriteEventsArray = defaults.array(forKey: "anEvent")! as! [AnEvent]
//            self.favoriteAllDataArray = defaults.array(forKey: "EventTab")! as![EventTab]
//        }
        favoriteEvent = defaults.object(forKey: "anEvent") as? [String: Any] ?? [:]
        favoriteTab = defaults.object(forKey: "EventTab") as? [String: Any] ?? [:]
        
        //print(passJSON!)
        let jsonFile = JSON(passJSON!)
        //print(jsonFile)
        let events = jsonFile["_embedded"]["events"].arrayValue
        
        for event in events {
            let anEventModel = AnEvent()
            let eventTabModel = EventTab()
            anEventModel.eventName = event["name"].stringValue
            anEventModel.eventType = event["classifications"][0]["segment"]["name"].stringValue
            anEventModel.veneName = event["_embedded"]["venues"][0]["name"].stringValue
            // print(anEventModel.veneName)
            
            anEventModel.favorite = false
            
            eventTabModel.buyTicketAt = event["url"].stringValue
            eventTabModel.favorite = false
            eventTabModel.seatMap = event["seatmap"]["staticUrl"].stringValue
            
            var stringForPriceRange = ""
            if let priceRange = event["priceRanges"].array {
                if let lowRange = priceRange[0]["min"].double {
                    stringForPriceRange += String(lowRange)
                } else {
                    stringForPriceRange += "N/A"
                }
                stringForPriceRange += " ~ "
                if let highRange = priceRange[0]["max"].double {
                    stringForPriceRange += String(highRange)
                } else {
                    stringForPriceRange += "N/A"
                }
                stringForPriceRange += " (USD)"
                
            } else {
                stringForPriceRange = "N/A"
            }
            eventTabModel.priceRange = stringForPriceRange
            
            var eventTypeString = ""
            eventTypeString += event["classifications"][0]["segment"]["name"].stringValue
            
            eventTypeString += " | "
            eventTypeString += event["classifications"][0]["genre"]["name"].stringValue
            eventTabModel.eventTypeCategory = eventTypeString
            eventTabModel.categoryToRequest = event["classifications"][0]["segment"]["name"].stringValue
            
            
            
            if let dateTime = event["dates"]["start"]["localTime"].string {
                anEventModel.date = event["dates"]["start"]["localDate"].stringValue + " | \(dateTime)"
                let tempDateString = event["dates"]["start"]["localDate"].stringValue + " \(dateTime)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterConverted = DateFormatter()
                dateFormatterConverted.dateFormat = "MMM dd,yyyy HH:mm:ss"
                
                if let date = dateFormatter.date(from: tempDateString) {
                    eventTabModel.date = dateFormatterConverted.string(from: date)
                } else {
                    print("There was an error decoding the string")
                }
            } else {
                anEventModel.date = event["dates"]["start"]["localDate"].stringValue
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let dateFormatterConverted = DateFormatter()
                dateFormatterConverted.dateFormat = "MMM dd,yyyy"
                
                if let date = dateFormatter.date(from: anEventModel.date) {
                    eventTabModel.date = dateFormatterConverted.string(from: date)
                } else {
                    print("There was an error decoding the string")
                }
            }
            anEventModel.dataUseToSort = event["dates"]["start"]["localDate"].stringValue
            eventTabModel.dataUseToSort = event["dates"]["start"]["localDate"].stringValue
            let nameArtistTeam = event["_embedded"]["attractions"].arrayValue
            
            for artistTeam in nameArtistTeam {
                anEventModel.artOrTeamNames.append(artistTeam["name"].stringValue)
                eventTabModel.artOrTeamNames.append(artistTeam["name"].stringValue)
                
            }
            eventTabModel.ticketStatus = event["dates"]["status"]["code"].stringValue
            eventTabModel.veneName = event["_embedded"]["venues"][0]["name"].stringValue
            eventTabModel.originalName = anEventModel.eventName
            
            // print(anEventModel.artOrTeamNames)
            eventsArray.append(anEventModel)
            allDataArray.append(eventTabModel)
            
//            print(eventTabModel.buyTicketAt)
//            print(eventTabModel.dataUseToSort)
//            print(eventTabModel.date)
//            print(eventTabModel.eventTypeCategory)
//            print(eventTabModel.priceRange)
//            print(eventTabModel.seatMap)
//            print(eventTabModel.ticketStatus)
//            print(eventTabModel.veneName)
            
        }
        eventsArray = eventsArray.sorted(by: {$0.dataUseToSort < $1.dataUseToSort})
        allDataArray = allDataArray.sorted(by: {$0.dataUseToSort < $1.dataUseToSort})
        
        
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)  as! TableViewCell
        cell.cellDelegate = self
        cell.favoriteButton.tag = indexPath.row
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEventCell")
        // Configure the cell...
        cell.eventName.text = "\(eventsArray[indexPath.row].eventName)\n\(eventsArray[indexPath.row].veneName)\n\(eventsArray[indexPath.row].date)"
        
        
        
        
        let uiImag1 = UIImage(named: "favorite-empty")
        let uiImag2 = UIImage(named: "favorite-filled")
        if (eventsArray[indexPath.row].favorite == false) {
            cell.favoriteButton.setImage(uiImag1, for: .normal)
        } else {
            cell.favoriteButton.setImage(uiImag2, for: .normal)
        }
        
        
        //cell.favoriteButton.setImage(uiImag, for: .normal)
        
        switch eventsArray[indexPath.row].eventType {
        case "Sports":
            cell.typeImage.image = UIImage(named: "sports")
        case "Music":
            cell.typeImage.image = UIImage(named: "music")
        case "Film":
            cell.typeImage.image = UIImage(named: "film")
        case "Miscellaneous":
            cell.typeImage.image = UIImage(named: "miscellaneous")
        case "Arts & Theatre":
            cell.typeImage.image = UIImage(named: "arts")

        default:
            cell.typeImage.image = nil
        }
        
    
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(eventsArray[indexPath.row].eventName)
        updateEventTabModel(inputModel: allDataArray[indexPath.row], indexSelect: indexPath.row)
        performSegue(withIdentifier: "detailPage", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPage" {
            let tbC = segue.destination as! UITabBarController
            //let nvControl = tbC.viewControllers![0] as! UINavigationController
            let eventVC = tbC.viewControllers![0] as! EventViewController
            eventVC.getModelFromTable = theEventTabModel!
            let artistVC = tbC.viewControllers![1] as! ArtistViewController
            artistVC.getEventModel = theEventTabModel!
            let locationVC = tbC.viewControllers![2] as! LocationViewController
            locationVC.modelFromTableView = theEventTabModel!
            let upComingVC = tbC.viewControllers![3] as! UpcomingEventController
            upComingVC.getEventModel = theEventTabModel!
            
            
            let twitterIMG = UIImage(named: "twitter")
            let twitter = UIBarButtonItem(image: twitterIMG, style: .plain, target: self, action: #selector(self.twitter))
            
            
            var heart: UIImage?
            if theEventTabModel?.favorite == true {
                heart = UIImage(named: "favorite-filled")
            } else {
                heart = UIImage(named: "favorite-empty")
            }
            let hertButton = UIBarButtonItem(image: heart, style: .plain, target: self, action: #selector(self.likeButton))
            self.tabBarNavigation = tbC.navigationItem
            self.tabBarNavigation!.rightBarButtonItems = [hertButton,twitter]
            
        }
    }
    func updateEventTabModel(inputModel: EventTab, indexSelect: Int) {
        theEventTabModel = inputModel
        theEventTabModel?.indexSelected = indexSelect
        theEventTabModel?.favorite = eventsArray[indexSelect].favorite
    }
    
    
    @objc func twitter(){

        
        let urlStr = "https://twitter.com/intent/tweet?text=Check out \(theEventTabModel!.originalName) located at \(theEventTabModel!.veneName). Website: \(self.theEventTabModel!.buyTicketAt) #CSCI571EventSearch"
        let url = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let pressUrl = URL(string: url!) {
            UIApplication.shared.open(pressUrl, options: [:])
        }
        
    }
    
    @objc func likeButton(){
      
        if theEventTabModel?.favorite == false {
            addFavorite(tag: theEventTabModel!.indexSelected)
            theEventTabModel!.favorite = true
            eventsArray[theEventTabModel!.indexSelected].favorite = true
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            self.view.showToast("\(theEventTabModel!.originalName) was added to favorites", position: .bottom, popTime: 1.5, dismissOnTap: false)
            
            let twitterIMG = UIImage(named: "twitter")
            let twitter = UIBarButtonItem(image: twitterIMG, style: .plain, target: self, action: #selector(self.twitter))
            var heart: UIImage?
            if theEventTabModel?.favorite == true {
                heart = UIImage(named: "favorite-filled")
            } else {
                heart = UIImage(named: "favorite-empty")
            }
            let hertButton = UIBarButtonItem(image: heart, style: .plain, target: self, action: #selector(self.likeButton))
            
            self.tabBarNavigation!.rightBarButtonItems = [hertButton,twitter]
            
            
            
            DispatchQueue.main.async(execute: tableView.reloadData)
            
        } else {
            removeFvaorite(tag: theEventTabModel!.indexSelected)
            theEventTabModel!.favorite = false
            eventsArray[theEventTabModel!.indexSelected].favorite = false
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            self.view.showToast("\(theEventTabModel!.originalName) was removed from favorites", position: .bottom, popTime: 1.5, dismissOnTap: false)
            let twitterIMG = UIImage(named: "twitter")
            let twitter = UIBarButtonItem(image: twitterIMG, style: .plain, target: self, action: #selector(self.twitter))
            var heart: UIImage?
            if theEventTabModel?.favorite == true {
                heart = UIImage(named: "favorite-filled")
            } else {
                heart = UIImage(named: "favorite-empty")
            }
            let hertButton = UIBarButtonItem(image: heart, style: .plain, target: self, action: #selector(self.likeButton))
            
            self.tabBarNavigation!.rightBarButtonItems = [hertButton,twitter]
            
            
            DispatchQueue.main.async(execute: tableView.reloadData)
        }
        
    }
    func changeTabBar() {
        
        
    }
    
    func configureTablieView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120.0
    }
    
    
    
    func tapButton(_ tag: Int, _ sender: UIButton) {
        let img1 = UIImage(named: "favorite-empty")
        let img2 = UIImage(named: "favorite-filled")
        
        //print(tag)
        if eventsArray[tag].favorite == false {
            eventsArray[tag].favorite = true
            sender.setImage(img2, for: .normal)
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            self.view.showToast("\(eventsArray[tag].eventName) was added to favorites", position: .bottom, popTime: 1.5, dismissOnTap: false)
            
      
            
            addFavorite(tag: tag)
            //let tempPrint = defaults.object(forKey: "anEvent") as? [String: Any]
            
            //print(self.favoriteEvent)
        }else {
            eventsArray[tag].favorite = false
            sender.setImage(img1, for: .normal)
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            self.view.showToast("\(eventsArray[tag].eventName) was removed from favorites", position: .bottom, popTime: 1.5, dismissOnTap: false)
            
            
            removeFvaorite(tag: tag)
            
        }
        
        
        
    }
    
    func addFavorite(tag: Int) {
        let evtName = eventsArray[tag].eventName
        let tabName = allDataArray[tag].originalName
        let dataEvt = ["eventName":eventsArray[tag].eventName, "artOrTeamNames":eventsArray[tag].artOrTeamNames, "dataUseToSort":eventsArray[tag].dataUseToSort,  "date":eventsArray[tag].date, "eventType":eventsArray[tag].eventType, "veneName":eventsArray[tag].veneName] as [String : Any]
        let datTab = ["artOrTeamNames":allDataArray[tag].artOrTeamNames, "buyTicketAt":allDataArray[tag].buyTicketAt, "categoryToRequest":allDataArray[tag].categoryToRequest, "dataUseToSort":allDataArray[tag].dataUseToSort, "date":allDataArray[tag].date, "eventTypeCategory":allDataArray[tag].eventTypeCategory, "favorite":allDataArray[tag].favorite, "originalName":allDataArray[tag].originalName, "priceRange":allDataArray[tag].priceRange, "seatMap":allDataArray[tag].seatMap, "ticketStatus":allDataArray[tag].ticketStatus, "veneName":allDataArray[tag].veneName] as [String : Any]
        if let tempDict = self.favoriteEvent["evtName"] {
            print(tempDict)
            self.favoriteEvent[evtName+evtName] = dataEvt
            self.favoriteTab[tabName+tabName] = datTab
            
        }else {
            self.favoriteEvent[evtName] = dataEvt
            self.favoriteTab[tabName] = datTab
        }
        
        
        
        defaults.set(self.favoriteEvent, forKey: "anEvent")
        defaults.set(self.favoriteTab, forKey: "eventTab")
    }
    func removeFvaorite(tag: Int) {
        let evtName = eventsArray[tag].eventName
        let tabName = allDataArray[tag].originalName
        
        self.favoriteEvent.removeValue(forKey: evtName)
        self.favoriteTab.removeValue(forKey: tabName)
        defaults.set(self.favoriteEvent, forKey: "anEvent")
        defaults.set(self.favoriteTab, forKey: "eventTab")
    }
    
 
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//
//        self.navigationItem.title = " "
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        super.viewWillAppear(animated)
//        self.navigationItem.title = "My Title"
//    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

