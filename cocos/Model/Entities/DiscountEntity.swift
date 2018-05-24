//
//  DiscountEntity.swift
//  cocos
//
//  Created by MIGUEL on 8/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class DiscountEntity : NSObject {
    var id : Int = 0
    var name : String = ""
    var porc : Float = 0.0
    var price : Float = 0.0
    var photo : String = ""
    var terms_condition : String = ""
    var descrip : String = ""
    
    class func getDiscountsFromJSONArray(fromJSONArray jsonArray:[JSON]?)->[DiscountEntity]?{
        var list : [DiscountEntity] = []
        if let data = jsonArray {
            for json in data {
                list.append(DiscountEntity.getDiscountFromJSON(fromJSON: json)!)
            }
        }
        return list
    }
    
    class func getDiscountFromJSON(fromJSON json : JSON?)->DiscountEntity?{
        if let data = json {
           let discount = DiscountEntity()
            discount.id = data["id"].intValue
            discount.name = data["name"].stringValue
            discount.porc = data["porc"].floatValue
            discount.price = data["price"].floatValue
            discount.photo = data["photo"].stringValue
            discount.terms_condition = data["terms_condition"].stringValue
            discount.descrip = data["description"].stringValue
            return discount
        }
        return nil
    }
    
}
