//
//  DetailViewController.swift
//  Foursquare
//
//  Created by sts on 12/19/17.
//  Copyright © 2017 mingah. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import SDWebImage
import IDMPhotoBrowser

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var _venue : VenueModel!

    @IBOutlet weak var ui_mapview: MKMapView!
    @IBOutlet weak var ui_lblName: UILabel!
    @IBOutlet weak var ui_lblAddress: UILabel!
    @IBOutlet weak var ui_lblRating: UILabel!
    @IBOutlet weak var ui_lblStats: UILabel!
    @IBOutlet weak var ui_photoCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = _venue.name
        
        initUI()
        fetchDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initUI() {
        
        ui_lblName.text = _venue.name
        if _venue.contact.isEmpty {
            ui_lblAddress.text = "ADD : \(_venue.address)"
        } else {
            ui_lblAddress.text = "ADD : \(_venue.address)\nTEL : \(_venue.contact)"
        }
     
        let location = CLLocationCoordinate2D(latitude: _venue.lat,
                                              longitude: _venue.lng)
        
        let regionRadius : CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        ui_mapview.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        ui_mapview.addAnnotation(annotation)
    }
    
    
    func fetchDetail() {
        
        let URL = "\(Constants.DETAIL_URL)\(_venue.id)?client_id=\(Constants.CLIENTID)&client_secret=\(Constants.SECRET)&v=20171219"
        
        Alamofire.request(URL, method:.get)
            .responseJSON { response in
                
                if response.result.isFailure {
                    return
                }
                
                if let result = response.result.value  {
                    
                    let dict = JSON(result)
                    let response = dict["response"]
                    let venue = response["venue"]
                        
                    self._venue = VenueModel(dict:venue)
                    self.displayInfo()

                }
                
        }
    }
    
    func displayInfo() {
        
        //initUI()
        
        ui_lblRating.text = "Rating : \(_venue.rating)"
        ui_lblStats.text = "Stats : \(_venue.users)/\(_venue.checkin) "
        
        self.ui_photoCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return _venue.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let placeholder = UIColor(netHex: Constants.LIGHT_GRAY_COLOR)
        cell.ui_image.sd_setImage(with: URL(string:_venue.photos[indexPath.item]), placeholderImage: UIImage(color: placeholder))
        
        return cell
            
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var photos = [IDMPhoto]()
        
        for one in _venue.photos {
            photos.append(IDMPhoto(url: URL(string: one)))
        }
        
        let browser = IDMPhotoBrowser(photos: photos)!
        browser.displayActionButton = true
        browser.displayArrowButton = false
        
        browser.displayCounterLabel = false
        browser.displayDoneButton = false
        browser.autoHideInterface = false
        browser.setInitialPageIndex(UInt(indexPath.item))
        
        DispatchQueue.main.async(execute:  {
            self.present(browser, animated: true, completion: nil)
        })
        
    }

}
