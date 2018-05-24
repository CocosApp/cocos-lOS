//
//  FavoritePlaceEntity.swift
//  cocos
//
//  Created by MIGUEL on 22/04/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class FavoritePlaceEntity : NSObject {
    var id : Int = 0
    var place : PlacesEntity?
    
    class func getPlacesFromJSONArray(fromJSONArray jsonArray: [JSON]?)->[FavoritePlaceEntity]? {
        var places : [FavoritePlaceEntity] = []
        if let data = jsonArray {
            for item in data {
                places.append(FavoritePlaceEntity.getPlaceFromJSON(fromJSON: item)!)
            }
        }
        return places
    }
    class func getPlaceFromJSON(fromJSON json : JSON?) -> FavoritePlaceEntity? {
        if let data = json {
            let place = FavoritePlaceEntity()
            place.id = data["id"].intValue
            place.place = PlacesEntity.getPlaceFromJSON(fromJSON: data["restaurant"])
            return place
        }
        return nil
    }
}
