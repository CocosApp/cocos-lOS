//
//  PlaceDetailController.swift
//  cocos
//
//  Created by MIGUEL on 7/05/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class PlaceDetailController : NSObject {
    static let controller = PlaceDetailController()
    
    func getDetail(placeId:String, success: @escaping (_ response : PlaceDetailEntity)->Void, failure: @escaping (_ error: NSError)->Void){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        PlaceDetailService.service.getPlaceDetail(user.token, placeId: placeId, success: { (response) in
            let entity = PlaceDetailEntity.getDetailFromJSON(fromJSON: response)
            success(entity!)
        }, failure: failure)
    }
    
    func addFavoritePlace(placeId:String, success: @escaping (_ response:NSDictionary)->Void,failure: @escaping (_ error: NSError)->Void){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        FavoriteService.sharedService.addFavoritePlace(token: user.token,idPlace:placeId, success: { (response) in
            let entity = response.dictionaryValue
            success(entity as NSDictionary)
        },failure: failure)
    }
    
}
