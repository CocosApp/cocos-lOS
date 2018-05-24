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
        let proc : String = String(promotion.porc)
        self.amountDiscount.text = "\(proc)%"
    }
}
