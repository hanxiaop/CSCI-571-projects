//
//  ViewController.swift
//  homework9
//
//  Created by XIAOPENG HAN on 11/22/18.
//  Copyright © 2018 XIAOPENG HAN. All rights reserved.
//

import UIKit
import CoreLocation
import McPicker
import LUAutocompleteView
import EasyToast
import Alamofire
import SwiftyJSON
import SwiftSpinner
import SearchTextField


class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, CellDelegate {
   
    
 
    var whichLocationToUse = "current"
    // create here location object
    let hereLocation = CLLocationManager()
    var tabBarNavigation: UINavigationItem?
    var hereLocationLATLNG: [String: String] = [:]
    var jsonPlaceEventFile: JSON = []
    var autoCompletedJSON: JSON?
    var autoCompleteArray: [String] = []
    
    let categorys: [[String]] = [
        ["All","Music","Sports","Arts & Theatre","Film","Miscellaneous"]
    ]
    let unitPickSource = ["miles","kms"]
    let cloudUrl = "http://hw8proj-env-1.rj7bsmp3zx.us-east-2.elasticbeanstalk.com/apiRequest?"
    
    var favoriteToDetail: [String: Any] = [:]
    var modelToSend = EventTab()
    
//    private let elements = (1...100).map { "\($0)" }
//    private let autoComplete = LUAutocompleteView()
    
    let defaults = UserDefaults.standard
    //var storedEventsArray = [:]
    //var storedAllDataArray = [:]
    var favoriteEventsArray: [String: Any] = [:]
    var favoriteAllDataArray: [String: Any] = [:]
    var eventArray: [Any] = []
    var allDataArray: [Any] = []
    
    
    
    @IBOutlet weak var searchViewControl: UIView!
    @IBOutlet weak var favoriteViewControl: UITableView!
    
    @IBOutlet weak var noFaviteData: UIView!
    
    
    @IBOutlet weak var keywordText: SearchTextField!
    @IBOutlet weak var categoryText: McTextField!
    @IBOutlet weak var distanceText: UITextField!
    @IBOutlet weak var unitsPick: UIPickerView!
    @IBOutlet weak var customLocationText: UITextField!
    
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    
    
    @IBAction func radioButtonPressed(_ sender: UIButton) {
        currentButton.backgroundColor = UIColor.lightGray
        customButton.backgroundColor = UIColor.white
        customLocationText.isUserInteractionEnabled = false
        customLocationText.text = ""
        customLocationText.backgroundColor = UIColor.rgb(red: 249, green: 249, blue: 249)
        
    }
    @IBAction func radioButtonCustom(_ sender: UIButton) {
        currentButton.backgroundColor = UIColor.white
        customButton.backgroundColor = UIColor.lightGray
        customLocationText.isUserInteractionEnabled = true
        customLocationText.backgroundColor = UIColor.white
     
    }
    
    @IBAction func doAutoComplete(_ sender: SearchTextField) {
        //print(keywordText.text!)
        let requestWord = keywordText.text!
        let formattedRequtst = requestWord.replacingOccurrences(of: " ", with: "+")
        let url = cloudUrl + "autoCompkeyword=\(formattedRequtst)"
        
       
    
        Alamofire.request(url, method: .get).responseJSON {
        response in
        if response.result.isSuccess {
        self.autoCompletedJSON = JSON(response.result.value!)
        //print(self.autoCompletedJSON!)
            var temArr: [String] = []
            if let namesArr = self.autoCompletedJSON!["_embedded"]["attractions"].array {
                for name in namesArr {
                    temArr.append(name["name"].stringValue)
                }
                
                
                self.keywordText.theme.bgColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                self.keywordText.theme.font = UIFont.systemFont(ofSize: 14)
                
                self.keywordText.theme.borderColor = UIColor (red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                self.keywordText.theme.separatorColor = UIColor (red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                self.keywordText.theme.cellHeight = 50
                
                self.keywordText.filterStrings(temArr)
                
            }
            
            
            
        } else {
        print("Error \(String(describing: response.result.error))")
        }
        
        }
        
   
        
    }
    
    
    @IBAction func segMentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            searchViewControl.alpha = 1
            favoriteViewControl.alpha = 0
            print("search")
        } else {
            let gesture = UITapGestureRecognizer(target: self, action:#selector(UIViewController.removeKeyboard))
            favoriteViewControl.addGestureRecognizer(gesture)
            
            gesture.cancelsTouchesInView = false
            print("favorite")
            
            searchViewControl.alpha = 0
            favoriteViewControl.alpha = 1
            self.favoriteEventsArray = defaults.object(forKey: "anEvent") as? [String: Any] ?? [:]
            self.favoriteAllDataArray = defaults.object(forKey: "eventTab") as? [String: Any] ?? [:]
            
            
            
            
            var tempArr: [Any] = []
            var tempArr2: [Any] = []
            for (key, value) in self.favoriteEventsArray {
                print(key)
                tempArr.append(value)
                
            }
            for (keys, values) in self.favoriteAllDataArray {
                print(keys)
                tempArr2.append(values)
                
            }
            eventArray = tempArr
            allDataArray = tempArr2
            
            DispatchQueue.main.async(execute: self.favoriteViewControl.reloadData)
            handleNoResults()
        }
        
        
    }
    func handleNoResults() {
        
        DispatchQueue.main.async(execute: self.favoriteViewControl.reloadData)
        if self.eventArray.count == 0 {
            self.favoriteViewControl.tableFooterView = UIView()
            
            //self.favoriteViewControl.backgroundView = UIView()
            
            self.favoriteViewControl.backgroundView = noFaviteData
            print("noresult")
            
            
        } else {
            self.favoriteViewControl.backgroundView = nil
            self.favoriteViewControl.tableFooterView = nil
            print("result")
        }
        
    }
    
    
    
    
    
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        if (keywordText.text == "" || (customLocationText.isUserInteractionEnabled == true &&  customLocationText.text == "" )) {
            
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            self.view.showToast("Keyword and location are mandatory fields", position: .bottom, popTime: 1.5, dismissOnTap: false)
        } else{
            let keyword: String = keywordText.text!
            let formattedKeyword = keyword.replacingOccurrences(of: " ", with: "+")
            var category: String = categoryText.text!
            if category == "Arts & Theatre" {
                category = "ArtandTheatre"
            }
            let distance:String
            if (distanceText.text == "") {
                distance = "10"
            }else {
                distance = distanceText.text!
            }
            
            var unit: String = unitPickSource[unitsPick.selectedRow(inComponent: 0)]
            if unit == "kms" {
                unit = "km"
            }
            let location: String
            var requestUrl = ""
            if (customLocationText.text != ""){
                location = customLocationText.text!
                let locationFormetted = location.replacingOccurrences(of: " ", with: "+")
                requestUrl = cloudUrl + "keyword=\(formattedKeyword)&distance=\(distance)&category=\(category)&unit=\(unit)&locationtype=\(locationFormetted)"
            }else {
                location = hereLocationLATLNG["lat"]! + "+" + hereLocationLATLNG["lng"]!
                requestUrl = cloudUrl + "keyword=\(formattedKeyword)&distance=\(distance)&category=\(category)&unit=\(unit)&herelocation=\(location)"
    
            }
            SwiftSpinner.show("Searching for events...")
            
            Alamofire.request(requestUrl, method: .get).responseJSON {
                response in
                if response.result.isSuccess {
                    self.jsonPlaceEventFile = JSON(response.result.value!)
                    print(self.jsonPlaceEventFile)
                    self.goToSecondPage()
                } else {
                    print("Error \(String(describing: response.result.error))")
                }
                
            }
            
            
        }
        
        
    }
    
    
    @IBAction func clearButton(_ sender: Any) {
        keywordText.text = ""
        categoryText.text = "All"
        distanceText.text = ""
        customLocationText.text = ""
        customLocationText.isUserInteractionEnabled = false
        customLocationText.backgroundColor = UIColor.rgb(red: 249, green: 249, blue: 249)
        currentButton.backgroundColor = UIColor.lightGray
        customButton.backgroundColor = UIColor.white
        
        unitsPick.selectRow(0, inComponent: 0, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initiate()
        
        hideKeyboard()
        
        favoriteViewControl.delegate = self
        favoriteViewControl.dataSource = self
        
    
        favoriteViewControl.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        configureTablieView()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.eventArray.count != 0 {
            return self.eventArray.count
        } else {
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete"){ ( action, view, completion) in
            let tempData = self.eventArray[indexPath.row] as! [String: Any]
            let tempData2 = self.allDataArray[indexPath.row] as! [String: Any]
            
            let evtName = tempData["eventName"]! as! String
            let tabName = tempData2["originalName"]! as! String
            self.favoriteEventsArray.removeValue(forKey: evtName)
            self.favoriteAllDataArray.removeValue(forKey: tabName)
            self.eventArray.remove(at: indexPath.row)
            self.allDataArray.remove(at: indexPath.row)
            self.handleNoResults()
            self.favoriteViewControl.deleteRows(at: [indexPath], with: .automatic)
            self.defaults.set(self.favoriteEventsArray, forKey: "anEvent")
            self.defaults.set(self.favoriteAllDataArray, forKey: "eventTab")
            
            completion(true)
            
        }
        action.backgroundColor = .red
        
        return action
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteViewControl.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        cell.cellDelegate = self
        let tempData = eventArray[indexPath.row] as! [String: Any]
        
        
        let evtName = tempData["eventName"]! as! String
        let veneName = tempData["veneName"] as! String
        let date = tempData["date"] as! String
        cell.favoriteButton.tag = indexPath.row
        cell.eventName.text = "\(evtName)\n\(veneName)\n\(date)"
        
        
        

        switch tempData["eventType"]! as! String {
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
    func configureTablieView() {
        self.favoriteViewControl.rowHeight = UITableView.automaticDimension
        self.favoriteViewControl.estimatedRowHeight = 120.0
    }
    
    
    
    func tapButton(_ tag: Int, _ sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        self.updateEvent(input: indexPath.row)
        
        

    }
    
    func updateEvent(input: Int){
        self.favoriteToDetail = self.allDataArray[input] as! [String : Any]
        let tempFile = self.allDataArray[input] as! [String : Any]
        
        self.modelToSend.artOrTeamNames = tempFile["artOrTeamNames"] as! Array
        self.modelToSend.buyTicketAt = tempFile["buyTicketAt"] as! String
        self.modelToSend.categoryToRequest = tempFile["categoryToRequest"] as! String
        self.modelToSend.dataUseToSort = tempFile["dataUseToSort"] as! String
        self.modelToSend.date = tempFile["date"] as! String
        self.modelToSend.eventTypeCategory = tempFile["eventTypeCategory"] as! String
        //self.modelToSend.favorite = tempFile["favorite"] as! Bool
        self.modelToSend.favorite = true
        self.modelToSend.veneName = tempFile["veneName"] as! String
        self.modelToSend.originalName = tempFile["originalName"] as! String
        self.modelToSend.priceRange = tempFile["priceRange"] as! String
        self.modelToSend.seatMap = tempFile["seatMap"] as! String
        self.modelToSend.ticketStatus = tempFile["ticketStatus"] as! String
        self.modelToSend.indexSelected = input
        performSegue(withIdentifier: "favoriteToResult", sender: self)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTableScreen" {
            let tableVC = segue.destination as! TableViewController
            tableVC.passJSON = jsonPlaceEventFile
            //print(jsonPlaceEventFile)
            
        }
        if segue.identifier == "favoriteToResult" {
            let tbC = segue.destination as! UITabBarController
            //let nvControl = tbC.viewControllers![0] as! UINavigationController
            let eventVC = tbC.viewControllers![0] as! EventViewController
            eventVC.getModelFromTable = modelToSend
            let artistVC = tbC.viewControllers![1] as! ArtistViewController
            artistVC.getEventModel = modelToSend
            let locationVC = tbC.viewControllers![2] as! LocationViewController
            locationVC.modelFromTableView = modelToSend
            let upComingVC = tbC.viewControllers![3] as! UpcomingEventController
            upComingVC.getEventModel = modelToSend
            
            
            let twitterIMG = UIImage(named: "twitter")
            let twitter = UIBarButtonItem(image: twitterIMG, style: .plain, target: self, action: #selector(self.twitter))
            
            
            var heart: UIImage?
            if modelToSend.favorite == true {
                heart = UIImage(named: "favorite-filled")
            } else {
                heart = UIImage(named: "favorite-empty")
            }
            let hertButton = UIBarButtonItem(image: heart, style: .plain, target: self, action: #selector(self.likeButton))
//            self.tabBarNavigation = tbC.navigationItem
//            self.tabBarNavigation!.rightBarButtonItems = [hertButton,twitter]
            self.tabBarNavigation = tbC.navigationItem
            tbC.navigationItem.rightBarButtonItems = [hertButton,twitter]
        }
        if segue.identifier == "noData" {
            
        }
    }
    @objc func twitter(){
        
        
        let urlStr = "https://twitter.com/intent/tweet?text=Check out \(modelToSend.originalName) located at \(modelToSend.veneName). Website: \(self.modelToSend.buyTicketAt) #CSCI571EventSearch"
        let url = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let pressUrl = URL(string: url!) {
            UIApplication.shared.open(pressUrl, options: [:])
        }
        
    }
    @objc func likeButton(){
        if modelToSend.favorite == true {
            let tempData = self.eventArray[modelToSend.indexSelected] as! [String: Any]
            let tempData2 = self.allDataArray[modelToSend.indexSelected] as! [String: Any]
            modelToSend.favorite = false
            let evtName = tempData["eventName"]! as! String
            let tabName = tempData2["originalName"]! as! String
            self.favoriteEventsArray.removeValue(forKey: evtName)
            self.favoriteAllDataArray.removeValue(forKey: tabName)
            self.eventArray.remove(at: modelToSend.indexSelected)
            self.allDataArray.remove(at: modelToSend.indexSelected)
            self.defaults.set(self.favoriteEventsArray, forKey: "anEvent")
            self.defaults.set(self.favoriteAllDataArray, forKey: "eventTab")
            DispatchQueue.main.async(execute: self.favoriteViewControl.reloadData)
            let twitterIMG = UIImage(named: "twitter")
            let twitter = UIBarButtonItem(image: twitterIMG, style: .plain, target: self, action: #selector(self.twitter))
            var heart: UIImage?
            if modelToSend.favorite == true {
                heart = UIImage(named: "favorite-filled")
            } else {
                heart = UIImage(named: "favorite-empty")
            }
            let hertButton = UIBarButtonItem(image: heart, style: .plain, target: self, action: #selector(self.likeButton))
            
            self.tabBarNavigation?.rightBarButtonItems = [hertButton, twitter]
            handleNoResults()
        }
        
    }
    
    
    
    
    func goToSecondPage() {
        SwiftSpinner.hide()
        let tempFile = self.jsonPlaceEventFile
        if let temfile22 = tempFile["_embedded"]["events"].array{
            performSegue(withIdentifier: "toTableScreen", sender: self)
            print(temfile22.count)
        } else {
            
            performSegue(withIdentifier: "noData", sender: self)
        }
        
        
        
    }
    

    
    func initiate() {
        currentButton.layer.cornerRadius = 12.5
        currentButton.layer.masksToBounds = true
        currentButton.layer.borderWidth = 1
        currentButton.layer.borderColor = UIColor.lightGray.cgColor
        customButton.layer.cornerRadius = 12.5
        customButton.layer.masksToBounds = true
        customButton.layer.borderColor = UIColor.lightGray.cgColor
        customButton.layer.borderWidth = 1
        keywordText.placeholder = "Enter keyword"
        distanceText.placeholder = "10"
        customLocationText.placeholder = "Type in the location"
        
        categoryText.delegate = self
        categoryText.text = "All"
        unitsPick.dataSource = self
        unitsPick.delegate = self
        
        
        hereLocation.delegate = self
        //get hundred meters
        hereLocation.desiredAccuracy = kCLLocationAccuracyHundredMeters
        hereLocation.requestAlwaysAuthorization()
        hereLocation.startUpdatingLocation()
        
        
        
        
        keywordText.text = ""
        distanceText.text = ""
        customLocationText.text = ""
        customLocationText.isUserInteractionEnabled = false
        customLocationText.backgroundColor = UIColor.rgb(red: 249, green: 249, blue: 249)
        
        // autocomplete
        //view.addSubview(autoComplete)
//        autoComplete.textField = keywordText
//        autoComplete.dataSource = self
//        autoComplete.delegate = self
//        autoComplete.rowHeight = 50
        
        
        
        
        
        let categoryMcPicker = McPicker(data: categorys)
        categoryText.inputViewMcPicker = categoryMcPicker
        categoryText.doneHandler = {[weak categoryText] (selections) in
            categoryText?.text = selections[0]!}
        categoryText.selectionChangedHandler = {[weak categoryText] (selections, componentChanged) in categoryText?.text = selections[componentChanged]!}
        //categoryField.cancelHandler = {[weak categoryField] in categoryField?.text = ""}
        categoryText.textFieldWillBeginEditingHandler = {[weak categoryText] (selections) in
            if categoryText?.text == "" {
                categoryText?.text = selections[0]
            }
        }
        
    }
    
    
    
    // update hereLocation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let hereLocValue = locations[locations.count-1]
        if hereLocValue.horizontalAccuracy > 0 {
            hereLocation.stopUpdatingLocation()
            let hereLat = String(hereLocValue.coordinate.latitude)
            let hereLng = String(hereLocValue.coordinate.longitude)
            hereLocationLATLNG = ["lat": hereLat, "lng": hereLng]
            
        }
    }
    // fail to get location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unitPickSource.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //valueSelected = unitPickSource[row] as String
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitPickSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        label.font = UIFont (name: "Helvetica Neue", size: 12)
        label.text =  unitPickSource[row]
        label.textAlignment = .center
        return label
    }
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}



//extension ViewController: LUAutocompleteViewDataSource {
//    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
//        let elementsThatMatchInput = elements.filter { $0.lowercased().contains(text.lowercased()) }
//        completion(elementsThatMatchInput)
//    }
//}


//extension ViewController: LUAutocompleteViewDelegate {
//    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
//        print(text + " was selected from autocomplete view")
//        autocompleteView.backgroundColor = UIColor.rgb(red: 249, green: 249, blue: 249)
//    }
//}


extension UIViewController {
    func hideKeyboard() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard))
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func removeKeyboard() {
        view.endEditing(true)
    }
}
