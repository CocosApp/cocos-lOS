//
//  FavoritePlaceCell.swift
//  cocos
//
//  Created by MIGUEL on 22/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class FavoritePlaceCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeBackgroundView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var likeOff : (()->Void)!
    
    @IBAction func likeButtonDidSelect(){
        self.likeOff()
    }
}
