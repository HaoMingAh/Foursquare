//
//  ViewController.swift
//  Foursquare
//
//  Created by sts on 12/19/17.
//  Copyright © 2017 mingah. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation

var g_latitude = 0.0
var g_longitude = 0.0

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var ui_tableView: UITableView!
    @IBOutlet weak var ui_searchbar: UISearchBar!
    
    var locationManager = CLLocationManager()
    
    var _timer : Timer?
    var _results = [VenueModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        self.title = R.string.HOME_TITLE
        
        ui_tableView.keyboardDismissMode = .onDrag
        
        search()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func search() {
        
        if g_longitude == 0 && g_latitude == 0 {
            return
        }
        

        var URL = Constants.SEARCH_URL + "\(g_latitude),\(g_longitude)"
        
        if let term = ui_searchbar.text {
            
            if term.count > 0 {
                URL += "&query=\(term)"
            }
        }
        
        Alamofire.request(URL, method:.get)
            .responseJSON { response in
                
                if response.result.isFailure {
                    return
                }
                
                if let result = response.result.value  {
                    
                    self._results.removeAll()
                    
                    let dict = JSON(result)
                
                    if let response = dict["response"].dictionary {
                        
                        if let venues = response["venues"]?.array {
                            
                            for one in venues {
                                
                                let venue = VenueModel(dict:one)
                                self._results.append(venue)
                                
                            }
                            
                            self.ui_tableView.reloadData()
                        }
                    }

                }
                
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if self._timer != nil {
            self._timer!.invalidate()
            self._timer = nil
        }
        
        self._timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.search), userInfo: nil, repeats: false)
        
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        
        search()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _results.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.selectionStyle = .none
        
        cell.entity = _results[indexPath.row]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        g_latitude = locValue.latitude
        g_longitude = locValue.longitude
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        search()
        
    }


}

