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
    var lat = 0
    var lng = 0
    var address = ""
    var url = ""
    
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
        }
    }
    
}
