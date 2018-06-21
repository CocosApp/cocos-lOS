//
//  CardPlacesEntity.swift
//  cocos
//
//  Created by MIGUEL on 21/06/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class CardPlacesEntity : NSObject {
    var id : Int = 0
    var name : String = ""
    var porc : Double = 0.0
    var places : [PlacesEntity] = []
    
    class func getCardPlacesFromJSONArray(fromJSONArray jsonArray:[JSON]?)->[CardPlacesEntity]?{
        var cardPlaces : [CardPlacesEntity] = []
        if let data = jsonArray {
            for json in data {
                cardPlaces.append(self.getCardPlaceFromJSON(fromJSON: json)!)
            }
        }
        return cardPlaces
    }
    
    class func getCardPlaceFromJSON(fromJSON json:JSON?)->CardPlacesEntity?{
        if let data = json {
            let entity = CardPlacesEntity()
            entity.id = data["id"].intValue
            entity.name = data["name"].stringValue
            entity.porc = data["porc"].doubleValue
            entity.places = PlacesEntity.getPlacesFromJSONArray(fromJSONArray: data["restaurants"].arrayValue)!
        }
        return nil
    }
    
}
