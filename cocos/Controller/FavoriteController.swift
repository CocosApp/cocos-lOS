//
//  FavoriteController.swift
//  cocos
//
//  Created by MIGUEL on 21/04/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class FavoriteController : NSObject {
    static let controller = FavoriteController()
    
    func getFavoritePlaces(success: @escaping (_ places: [FavoritePlaceEntity])->Void,failure: @escaping (_ error: NSError)->Void){
        let service = FavoriteService.sharedService
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        service.getFavoritePlaces(token: user.token, success: { (response:JSON) in
            let list = ResponseEntityFavoritePlace.getResponseFromJSON(fromJSON: response)
            success((list?.results)!)
        }, failure: failure)
    }
}
