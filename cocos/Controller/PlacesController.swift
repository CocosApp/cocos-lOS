//
//  PlacesController.swift
//  cocos
//
//  Created by MIGUEL on 16/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class PlacesController : NSObject {
    static let controller = PlacesController()
    var responseCategory : ResponseEntityPlaces?
    var responseNearMe : ResponseEntityPlaces?
    var responseDiscounts : ResponseEntityCards?
    var responseSubcategory : ResponseEntitySubCategory?
    
    private override init() {}
    
    func getPlaceList(_ token: String,success: @escaping (_ places : [PlacesEntity])->Void,failure : @escaping (_ error : NSError)-> Void){
        let service = PlacesService.sharedService
        service.getPlaceList(token: token, success: { (response:JSON)->Void in
            self.responseCategory = ResponseEntityPlaces.getResponseFromJSON(fromJSON: response)
            success((self.responseCategory?.results)!)
        }, failure: failure)
    }
    
    func getSubcategoryList(_ token: String,success: @escaping (_ subcategory:[SubcategoryEntity])->Void,failure: @escaping (_ error: NSError)->Void){
        let service = PlacesService.sharedService
        service.getSubcategoryList(token: token, success: { (response:JSON)->Void in
            self.responseSubcategory = ResponseEntitySubCategory.getResponseFromJSON(fromJSON: response)
            success((self.responseSubcategory?.results)!)
        }, failure: failure)
    }
    
    func getPlaceByPosition(_ token:String,lat:Double,long:Double, success: @escaping (_ places: [PlacesEntity])->Void,failure: @escaping (_ error : NSError)->Void){
        let service = PlacesService.sharedService
        service.getPlacesByGPS(token: token, lat: String(format:"%f",lat), long: String(format:"%f",long), success: { (response:JSON)->Void in
            self.responseNearMe = ResponseEntityPlaces.getResponseFromJSON(fromJSON: response)
            success((self.responseNearMe?.results)!)
        }, failure: failure)
    }
    
    func getDiscounts(_ token:String,success : @escaping (_ discounts:[CardEntity])->Void, failure: @escaping (_ error:NSError)->Void){
        let service = PlacesService.sharedService
        service.getDiscountList(token: token, success: { (response:JSON)->Void in
            self.responseDiscounts = ResponseEntityCards.getResponseFromJSON(fromJSON: response)
            success((self.responseDiscounts?.results)!)
        }, failure: failure)
    }
}
