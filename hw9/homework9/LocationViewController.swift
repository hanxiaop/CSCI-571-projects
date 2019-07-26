//
//  LocationViewController.swift
//  homework9
//
//  Created by XIAOPENG HAN on 11/24/18.
//  Copyright © 2018 XIAOPENG HAN. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire
import GoogleMaps



class LocationViewController: UIViewController {
    
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var cityText: UILabel!
    @IBOutlet weak var phoneText: UILabel!
    @IBOutlet weak var openHourText: UILabel!
    @IBOutlet weak var genRuleText: UILabel!
    @IBOutlet weak var childRuleText: UILabel!
    @IBOutlet weak var googleMapView: GMSMapView!
    
    
    @IBOutlet weak var scroolbaleView: UIScrollView!
    
    var resultJSON: JSON?
    var modelFromTableView: EventTab?
    
    var createVenueModel = VenueModel()
    let cloudUrl = "http://hw8proj-env-1.rj7bsmp3zx.us-east-2.elasticbeanstalk.com/apiRequest?"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        
        SwiftSpinner.show("Finding venue information...")
        let formattedVenue = modelFromTableView?.veneName.replacingOccurrences(of: " ", with: "+")
        let requestURL = cloudUrl + "venuekeyword=\(formattedVenue!)"
        
        
        Alamofire.request(requestURL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON = JSON(response.result.value!)
                self.resultJSON = responseJSON
                
                self.useJSONfile()
                
                self.useGoogleMap()
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }


        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func useGoogleMap() {
        let camera = GMSCameraPosition.camera(withLatitude: createVenueModel.latitude, longitude: createVenueModel.longtitude, zoom: 5.0)
        //let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //mapView.isMyLocationEnabled = true
        self.googleMapView.camera = camera
        
        
        // MARK: Create maker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: createVenueModel.latitude, longitude: createVenueModel.longtitude)
        marker.map = self.googleMapView
        
    }
    
    
    func useJSONfile () {
        if resultJSON != nil {
            SwiftSpinner.hide()
            
            if let venueObj = resultJSON!["_embedded"]["venues"].array {
                if venueObj[0]["address"]["line1"].string != nil {
                    createVenueModel.address = venueObj[0]["address"]["line1"].stringValue
                }
                createVenueModel.latitude = Double(venueObj[0]["location"]["latitude"].stringValue)!
                createVenueModel.longtitude = Double(venueObj[0]["location"]["longitude"].stringValue)!
                   // createVenueModel?.address = String(describing: address)
                
               //     createVenueModel?.address = "N/A"
                
                
                var tempAddrStr:String = ""
                if let city = venueObj[0]["city"]["name"].string {
                    tempAddrStr += city
                } else {
                    createVenueModel.address += "N/A"
                }
                if let state = venueObj[0]["state"]["stateCode"].string {
                    tempAddrStr += ", \(state)"
                } else {
                    tempAddrStr += "N/A"
                }
                createVenueModel.city = tempAddrStr
                if let phoneNumber = venueObj[0]["boxOfficeInfo"]["phoneNumberDetail"].string {
                    //print(phoneNumber)
                    createVenueModel.phoneNumbers = "\(phoneNumber)"
                } else {
                    createVenueModel.phoneNumbers = "N/A"
                }
                if let openHours = venueObj[0]["boxOfficeInfo"]["openHoursDetail"].string {
                    //print(openHours)
                    createVenueModel.openHours = "\(openHours)"
                }else {
                    createVenueModel.openHours = "N/A"
                }
                if let generalRule = venueObj[0]["generalInfo"]["generalRule"].string {
                    createVenueModel.generalRules = "\(generalRule)"
                } else {
                    createVenueModel.generalRules = "N/A"
                }
                if let childRule = venueObj[0]["generalInfo"]["childRule"].string {
                    createVenueModel.childRules = "\(childRule)"
                } else {
                    createVenueModel.childRules = "N/A"
                }
                
             
                addressText.text = createVenueModel.address
                cityText.text = createVenueModel.city
                phoneText.text = createVenueModel.phoneNumbers
                openHourText.text = createVenueModel.openHours
                genRuleText.text = createVenueModel.generalRules
                childRuleText.text = createVenueModel.childRules
                
                //self.useGoogleMap()
                
            }
            
            
            
        }
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
