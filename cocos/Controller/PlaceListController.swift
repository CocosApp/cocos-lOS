//
//  PlaceListController.swift
//  cocos
//
//  Created by MIGUEL on 13/04/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class PlaceListController : NSObject {
    
    static let controller = PlaceListController()
    
    var response : ResponseEntityPlaces!
    
    private override init() {
        super.init()
    }
    
    func loadList(_ token: String, subcategoryId:String,success: @escaping (_ places : [PlacesEntity])->Void, failure: @escaping (_ error:NSError)->Void){
        let service = PlacesService.sharedService
        service.getPlacesBySubcategory(token: token, subcategoryId: subcategoryId, success: { (response:JSON) in
            self.response = ResponseEntityPlaces.getResponseFromJSON(fromJSON: response)!
            success(self.response.results)
        }, failure: failure)
    }
    
    func loadNextList(_ token: String, success: @escaping(_ places: [PlacesEntity])->Void,failure: @escaping(_ error:NSError)->Void){
        let service = PlacesService.sharedService
        if response != nil && response.next != "" {
            let endpoint : String = (response.next)!
            service.getSubcategoryList(token: token, endpoint: endpoint, success: { (response) in
                self.response = ResponseEntityPlaces.getResponseFromJSON(fromJSON: response)!
                success(self.response.results)
            }, failure: failure)
        }
    }
    
}
