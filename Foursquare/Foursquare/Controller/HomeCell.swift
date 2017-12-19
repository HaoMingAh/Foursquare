//
//  HomeCell.swift
//  Foursquare
//
//  Created by sts on 12/19/17.
//  Copyright © 2017 mingah. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var ui_lblName: UILabel!
    @IBOutlet weak var ui_lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var entity: VenueModel? {
        
        didSet {
            
            ui_lblName.text = entity?.name
            ui_lblAddress.text = entity?.address
            
        }
        
    }

}
