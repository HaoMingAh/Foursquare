//
//  VenueModel.swift
//  Foursquare
//
//  Created by sts on 12/19/17.
//  Copyright © 2017 mingah. All rights reserved.
//

import Foundation
import SwiftyJSON

class VenueModel {

    var id = ""
    var name = ""
    var contact = ""
    var lat : Double = 0
    var lng : Double = 0
    var address = ""
    var url = ""
    var checkin = 0
    var users = 0
    var rating : Double = 0
    var photos = [String]()
    
    init(dict: JSON) {
        
        id = dict["id"].stringValue
        name = dict["name"].stringValue
        contact = dict["contact"].stringValue
        
        if let location = dict["location"].dictionary {
            if let addr = location["formattedAddress"]?.array {
                for one in addr {
                    address += "\(one.stringValue) "
                    
                }
            }
            
            lat = (location["lat"]?.doubleValue)!
            lng = (location["lng"]?.doubleValue)!
        }
        
        if let contact = dict["contact"].dictionary {
            if let phone = contact["formattedPhone"]?.string {
                self.contact = phone
            }
        }
        
        if let stats = dict["stats"].dictionary {
            checkin = (stats["checkinsCount"]?.intValue)!
            users = (stats["usersCount"]?.intValue)!
        }
        
        if let rating = dict["rating"].double {
            self.rating = rating
        }
        
        if let photos = dict["photos"].dictionary {
            if let groups = photos["groups"]?.array {
                
                if groups.count > 0 {
                    if let groups0 = groups[0].dictionary {
                        if let items = groups0["items"]?.array {
                            
                            for one in items {
                                
                                let prefix = one["prefix"].stringValue
                                let suffix = one["suffix"].stringValue
                                
                                let url = "\(prefix)512x512\(suffix)"
                                self.photos.append(url)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
