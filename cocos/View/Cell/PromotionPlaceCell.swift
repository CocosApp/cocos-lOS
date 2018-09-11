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
        var descriptionAmount : String!
        if promotion.porc != 0 {
            if promotion.card != nil{
                let cardName : String = (promotion.card?.name)!
                self.titleDiscount.text = cardName
            }
            else{
                self.titleDiscount.text = promotion.name
            }
            let proc : String = String(promotion.porc)
            descriptionAmount = "\(proc)%"
        }
        else if promotion.price != 0{
            if promotion.card != nil{
                let cardName : String = (promotion.card?.name)!
                let descName : String = promotion.name
                self.titleDiscount.text = "\(cardName) \(descName)"
            }
            else{
                self.titleDiscount.text = promotion.name
            }
            //self.titleDiscount.text = promotion.name
            let proc : String = String(promotion.price)
            descriptionAmount = "S/.\(proc)"
        }
        else {
            if promotion.card != nil {
                let cardName : String = (promotion.card?.name)!
                let descName : String = promotion.name
                self.titleDiscount.text = "\(cardName) \(descName)"
            }else{
                self.titleDiscount.text = promotion.name
            }
            //self.titleDiscount.text = promotion.name
            descriptionAmount = promotion.promotion
        }
        self.amountDiscount.text = descriptionAmount
    }
}
