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
    
    private override init() {
        super.init()
    }
    
    func loadList(_ token: String, subcategoryId:String,latitude:String,longitude:String,success: @escaping (_ places : [PlacesEntity])->Void, failure: @escaping (_ error:NSError)->Void){
        let service = PlacesService.sharedService
        service.getPlacesBySubcategory(token: token, subcategoryId: subcategoryId,latitude: latitude,longitude: longitude, success: { (response:JSON) in
            let list = ResponseEntityPlaces.getResponseFromJSON(fromJSON: response)
            success((list?.results)!)
        }, failure: failure)
    }
}
