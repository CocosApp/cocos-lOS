//
//  ResponseEntity.swift
//  cocos
//
//  Created by MIGUEL on 19/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class ResponseEntityPlaces : NSObject {
    var count: Int = 0
    var next:String = ""
    var results:[PlacesEntity] = []
    
    class func getResponseFromJSON(fromJSON json:JSON?)->ResponseEntityPlaces?{
        if let data = json {
            let response = ResponseEntityPlaces()
            response.count = data["count"].intValue
            response.next = data["next"].stringValue
            response.results = PlacesEntity.getPlacesFromJSONArray(fromJSONArray: data["results"].array)!
            return response
        }
        return nil
    }
}

class ResponseEntityDiscounts : NSObject {
    var count: Int = 0
    var next: String = ""
    var results:[DiscountEntity] = []
    class func getResponseFromJSON(fromJSON json : JSON?)->ResponseEntityDiscounts?{
        if let data = json{
            let response = ResponseEntityDiscounts()
            response.count = data["count"].intValue
            response.next = data["next"].stringValue
            response.results = DiscountEntity.getDiscountsFromJSONArray(fromJSONArray: data["results"].array)!
            return response
        }
        return nil
    }
}

class ResponseEntityCards : NSObject {
    var count: Int = 0
    var next : String = ""
    var results:[CardEntity] = []
    class func getResponseFromJSON(fromJSON json : JSON?)->ResponseEntityCards?{
        if let data = json{
            let response = ResponseEntityCards()
            response.count = data["count"].intValue
            response.next = data["next"].stringValue
            response.results = CardEntity.getCardsFromJSONArray(fromJSONArray: data["results"].array)!
            return response
        }
        return nil
    }
}

class ResponseEntitySubCategory : NSObject {
    var count : Int = 0
    var next : String = ""
    var results:[SubcategoryEntity] = []
    class func getResponseFromJSON(fromJSON json : JSON?)->ResponseEntitySubCategory?{
        if let data = json {
            let response = ResponseEntitySubCategory()
            response.count = data["count"].intValue
            response.next = data["next"].stringValue
            response.results = SubcategoryEntity.getSubcategoriesFromJSONArray(fromJSONArray: data["results"].array)!
            return response
        }
        return nil
    }
}

class ResponseEntityFavoritePlace : NSObject {
    var count : Int = 0
    var next : String = ""
    var results:[FavoritePlaceEntity] = []
    class func getResponseFromJSON(fromJSON json : JSON?)->ResponseEntityFavoritePlace?{
        if let data = json {
            let response = ResponseEntityFavoritePlace()
            response.count = data["count"].intValue
            response.next = data["next"].stringValue
            response.results = FavoritePlaceEntity.getPlacesFromJSONArray(fromJSONArray: data["results"].array)!
            return response
        }
        return nil
    }
}
