//
//  ArtistViewController.swift
//  homework9
//
//  Created by XIAOPENG HAN on 11/24/18.
//  Copyright © 2018 XIAOPENG HAN. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyJSON
import Alamofire
import Kingfisher


class ArtistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ButtonDelegate {
   
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var getEventModel: EventTab?
    var artistJSON: [JSON] = []
    var pictureJSON: [JSON] = []
    var checkDataType: String?
    
    var images: [[UIImage]] = [
    ]
    var imagesUrl: [[String]] = []
    var artists: [[String]] = []
    var titleForDisplay: [String] = []
    var artistsModel: [ArtistModel] = []
    
    let cloudUrl = "http://hw8proj-env-1.rj7bsmp3zx.us-east-2.elasticbeanstalk.com/apiRequest?"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        checkDataType = getEventModel?.categoryToRequest
        SwiftSpinner.show("Fetching Artist Info...")
        DispatchQueue.main.async(execute: self.collectionView.reloadData)
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
//        print(getEventModel?.categoryToRequest as Any)
        titleForDisplay.append((getEventModel?.artOrTeamNames[0])!)
        if ((getEventModel?.artOrTeamNames.count)! > 1) {
            if let secondArtist = getEventModel?.artOrTeamNames[1] {
                titleForDisplay.append(secondArtist)
            }
        }
//
        for aritst in titleForDisplay {
            let formattedArtist = aritst.replacingOccurrences(of: " ", with: "+")
            let requestURL = cloudUrl + "keyword=\(formattedArtist)&searchType=image"
            Alamofire.request(requestURL, method: .get).responseJSON {
                response in
                if response.result.isSuccess {
                    let responseJSON = JSON(response.result.value!)
                    self.pictureJSON.append(responseJSON)
//                    print(self.pictureJSON.count as Any)
//                    print(self.getEventModel?.artOrTeamNames.count as Any)
                    
                    self.checkJSONFile()
                } else {
                    print("Error \(String(describing: response.result.error))")
                }


            }
            let requestURLArtist = cloudUrl + "keyword=\(formattedArtist)"
            Alamofire.request(requestURLArtist, method: .get).responseJSON {
                response in
                if response.result.isSuccess {
                    let responseJSON = JSON(response.result.value!)
                    self.artistJSON.append(responseJSON)
                    
                    
                    //                    print(self.pictureJSON.count as Any)
                    //                    print(self.getEventModel?.artOrTeamNames.count as Any)
                    
                    self.checkJSONFile()
                } else {
                    print("Error \(String(describing: response.result.error))")
                }
                
                
            }

        }
        
        
        
        
        if getEventModel?.categoryToRequest == "Music" {
            
            
        }
        
    }
    
    func checkJSONFile (){
        if self.pictureJSON.count == getEventModel!.artOrTeamNames.count && self.artistJSON.count == getEventModel!.artOrTeamNames.count {
            
            
            if (self.pictureJSON.count > 1 && self.titleForDisplay[0].lowercased() != pictureJSON[0]["queries"]["request"][0]["searchTerms"].stringValue.lowercased()) {
                let tempJSON = pictureJSON[0]
                pictureJSON[0] = pictureJSON[1]
                pictureJSON[1] = tempJSON
            }else {
              
            }
            
            
            
            if (getEventModel?.categoryToRequest != "Music") {
                for jsons in self.pictureJSON {
                    let items = jsons["items"].array
                    var tempArr: [String] = []
                    for item in items! {
                        tempArr.append(item["link"].stringValue)
                       
                        
                    }
                    imagesUrl.append(tempArr)
                    
                    
                }
            }else {
                if self.pictureJSON.count > 1 {
//                    print(pictureJSON[0]["queries"]["request"][0]["searchTerms"].stringValue.lowercased())
////                    print(pictureJSON[0])
////                    print(self.titleForDisplay[0].lowercased())
//                    print(pictureJSON[1]["queries"]["request"][0]["searchTerms"].stringValue.lowercased())
////                    print(self.titleForDisplay[1].lowercased())
//                    print(pictureJSON[0])
                    if (self.titleForDisplay[0].lowercased() != pictureJSON[0]["queries"]["request"][0]["searchTerms"].stringValue.lowercased()) {
                        let tempJSON = pictureJSON[0]
                        pictureJSON[0] = pictureJSON[1]
                        pictureJSON[1] = tempJSON
                    }
                    if (self.titleForDisplay[0].lowercased() != artistJSON[0]["artists"]["items"][0]["name"].stringValue.lowercased()) {
                        let tempJSON2 = artistJSON[0]
                        artistJSON[0] = artistJSON[1]
                        artistJSON[1] = tempJSON2
                    }
                }
                for jsons in self.pictureJSON {
                    let items = jsons["items"].array
                    var tempArr: [String] = []
                    for item in items! {
                        tempArr.append(item["link"].stringValue)
                    }
                    imagesUrl.append(tempArr)
                    
                    
                }
                
                for json in self.artistJSON {
                    let tempModel = ArtistModel()
                    let tempFollower = json["artists"]["items"][0]["followers"]["total"].intValue
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                    tempModel.followers = numberFormatter.string(from: NSNumber(value:tempFollower))!
                    tempModel.nameOfArtist = json["artists"]["items"][0]["name"].stringValue
                    tempModel.popularity = String(json["artists"]["items"][0]["popularity"].intValue)
                    tempModel.linkToSpotify = json["artists"]["items"][0]["external_urls"]["spotify"].stringValue
                    artistsModel.append(tempModel)
                }
                
            
                
                
            }
         
            SwiftSpinner.hide()
            DispatchQueue.main.async(execute: self.collectionView.reloadData)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imagesUrl.count
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            var numOfItems = images[0].count
//            if self.checkDataType == "Music" {
//                numOfItems += 1
//            }
//            return numOfItems
//
//        } else {
//            if section == 1 {
//                var numOfItems = images[1].count
//                if self.checkDataType == "Music" {
//                    numOfItems += 1
//                }
//                return numOfItems
//
//            }
//
//        }
        var numOfItems = imagesUrl[0].count
            if self.checkDataType == "Music" {
                numOfItems += 1
            }
            return numOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.checkDataType == "Music" {
            if indexPath.section == 0 {
                if indexPath.item == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseArtist", for: indexPath) as! ArtistInfomationCollectionViewCell
                    cell.buttonDelegate = self
                    cell.spotifyButton.tag = indexPath.section
                    cell.artistFollowers.text = self.artistsModel[indexPath.section].followers
                    cell.artistName.text = self.artistsModel[indexPath.section].nameOfArtist
                    cell.popularity.text = self.artistsModel[indexPath.section].popularity
                    
                    
                    //cell.artistName =
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resuableCell", for: indexPath) as! ArtistCollectionViewCell
                    cell.imageChange.kf.setImage(with: URL(string: imagesUrl[indexPath.section][indexPath.item-1]))
                    return cell
                }
            } else {
                if indexPath.item == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseArtist", for: indexPath) as! ArtistInfomationCollectionViewCell
                    cell.buttonDelegate = self
                    cell.spotifyButton.tag = indexPath.section
                    cell.artistFollowers.text = self.artistsModel[indexPath.section].followers
                    cell.artistName.text = self.artistsModel[indexPath.section].nameOfArtist
                    cell.popularity.text = self.artistsModel[indexPath.section].popularity
                    
                    
                    //cell.artistName =
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resuableCell", for: indexPath) as! ArtistCollectionViewCell
                    cell.imageChange.kf.setImage(with: URL(string: imagesUrl[indexPath.section][indexPath.item-1]))
                    return cell
                }
                
                
                
            }
            
//            if images.count > 1 {
//                if indexPath.section == 1 {
//                    if indexPath.item == 0 {
//                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseArtist", for: indexPath) as! ArtistInfomationCollectionViewCell
//
//                        //cell.artistName =
//                        return cell
//                    } else {
//                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resuableCell", for: indexPath) as! ArtistCollectionViewCell
//                        cell.imageChange.kf.setImage(with: URL(string: imagesUrl[indexPath.section][indexPath.item-1]))
//                        return cell
//                    }
//
//
//
//                }
//
//            }
            
            
//
//            if indexPath.item == 0 {
//                return collectionView.dequeueReusableCell(withReuseIdentifier: "reuseArtist", for: indexPath) as! ArtistInfomationCollectionViewCell
//            } else {
//                return  collectionView.dequeueReusableCell(withReuseIdentifier: "resuableCell", for: indexPath) as! ArtistCollectionViewCell
//            }
            
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resuableCell", for: indexPath) as! ArtistCollectionViewCell
//            if indexPath.section == 0 {
//                cell.imageChange.kf.setImage(with: URL(string: imagesUrl[0][indexPath.item]))   //= images[0][indexPath.item]
//            }
//            if images.count > 1 {
//                if indexPath.section == 1 {
//                    cell.imageChange.kf.setImage(with: URL(string: imagesUrl[1][indexPath.item]))
//
//
//                }
//
//            }
            cell.imageChange.kf.setImage(with: URL(string: imagesUrl[indexPath.section][indexPath.item]))
            
            //cell.imageChange.image = images[indexPath.section][indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "resuableHeader", for: indexPath) as! TitleCollectionReusableView
        headerView.title.text = titleForDisplay[indexPath.section]
        return headerView
    }
    
    func tapButton(_ tag: Int, _ sender: UIButton) {
        let tickURL = self.artistsModel[tag].linkToSpotify
        
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

