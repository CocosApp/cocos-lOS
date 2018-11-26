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
        
        if (promotion.card != nil && promotion.card!.name != ""){
            
            if(promotion.porc != 0){
                self.titleDiscount.text = promotion.card?.name
                self.amountDiscount.text = "\(promotion.porc)%"
            }else{
                let cardName : String = (promotion.card?.name)!
                let descName : String = promotion.name
                if(promotion.price != 0) {
                    self.titleDiscount.text = "\(cardName) \(descName)"
                    self.amountDiscount.text = "S/ \(promotion.price)"
                    
                }else{
                    self.titleDiscount.text = "\(cardName) \(descName)"
                    self.amountDiscount.text = promotion.promotion
                }
            }
        }else{
            self.titleDiscount.text = promotion.name
            
            if(promotion.porc != 0){
                self.amountDiscount.text = "\(promotion.porc)%"
            }else{
                if(promotion.price != 0){
                    self.amountDiscount.text = "S/ \(promotion.price)"
                    
                }else{
                    self.amountDiscount.text = promotion.promotion
                }
            }
        }
    }
}
