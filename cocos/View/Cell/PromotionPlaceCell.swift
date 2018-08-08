//
//  PromotionPlaceCell.swift
//  cocos
//
//  Created by MIGUEL on 7/05/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class PromotionPlaceCell : UITableViewCell {
    @IBOutlet weak var titleDiscount : UILabel!
    @IBOutlet weak var amountDiscount : UILabel!
    
    var promotion : PromotionEntity!{
        didSet{
            self.setup()
        }
    }
    
    func setup(){
        self.titleDiscount.text = promotion.name
        var descriptionAmount : String!
        if promotion.porc != 0 {
            let proc : String = String(promotion.porc)
            descriptionAmount = "\(proc)%"
        }
        else if promotion.price != 0{
            let proc : String = String(promotion.porc)
            descriptionAmount = "S/.\(proc)"
        }
        else {
            descriptionAmount = promotion.promotion
        }
        self.amountDiscount.text = descriptionAmount
    }
}
