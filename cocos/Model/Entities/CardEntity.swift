//
//  CardEntity.swift
//  cocos
//
//  Created by MIGUEL on 8/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class CardEntity : NSObject {
    var id : Int = 0
    var name : String = ""
    var photo : String = ""
    
    class func getCardsFromJSONArray(fromJSONArray jsonArray:[JSON]?)->[CardEntity]?{
        var list : [CardEntity] = []
        if let data = jsonArray {
            for json in data {
                list.append(CardEntity.getCardFromJSON(fromJSON: json)!)
            }
        }
        return list
    }
    
    class func getCardFromJSON(fromJSON json : JSON?)->CardEntity?{
        if let data = json {
            let card = CardEntity()
            card.id = data["id"].intValue
            card.name = data["name"].stringValue
            card.photo = data["photo"].stringValue
            return card
        }
        return nil
    }
}
