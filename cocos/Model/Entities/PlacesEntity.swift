//
//  PlacesEntity.swift
//  cocos
//
//  Created by MIGUEL on 8/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class PlacesEntity : NSObject {
    var id : Int = 0
    var name : String = ""
    var photo : String = ""
    var subcategory : [SubcategoryEntity]!
    
    class func getPlacesFromJSONArray(fromJSONArray jsonArray: [JSON]?)->[PlacesEntity]? {
        var places : [PlacesEntity] = []
        if let data = jsonArray {
            for item in data {
                places.append(PlacesEntity.getPlaceFromJSON(fromJSON: item)!)
            }
        }
        return places
    }
    class func getPlaceFromJSON(fromJSON json : JSON?) -> PlacesEntity? {
        if let data = json {
            let place = PlacesEntity()
            place.id = data["id"].intValue
            place.name = data["name"].stringValue
            place.photo = data["photo1"].stringValue
            place.subcategory = SubcategoryEntity.getSubcategoriesFromJSONArray(fromJSONArray: data["subcategory"].array)
            return place
        }
        return nil
    }
}
