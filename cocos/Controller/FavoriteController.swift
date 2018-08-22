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
    
    var response : ResponseEntityFavoritePlace!
    
    func getFavoritePlaces(success: @escaping (_ places: [FavoritePlaceEntity])->Void,failure: @escaping (_ error: NSError)->Void){
        let service = FavoriteService.sharedService
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        service.getFavoritePlaces(token: user.token, success: { (response:JSON) in
            self.response = ResponseEntityFavoritePlace.getResponseFromJSON(fromJSON: response)
            success(self.response.results)
        }, failure: failure)
    }
    
    func getNextFavoritePlaces(success: @escaping (_ places : [FavoritePlaceEntity])->Void,failure: @escaping (_ error: NSError)->Void){
        let service = FavoriteService.sharedService
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        if response != nil && response.next != "" {
            let endpoint : String = response.next
            service.getFavoritePlaces(token: user.token, endpoint: endpoint, success: { (response) in
                self.response = ResponseEntityFavoritePlace.getResponseFromJSON(fromJSON: response)!
                success(self.response.results)
            }, failure: failure)
        }
    }
    
    
    
    func deleteFavoritePlace(placeId:String , success: @escaping ()->Void,failure: @escaping (_ error: NSError)->Void) {
        let service = FavoriteService.sharedService
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        service.deleteFavoritePlace(token: user.token,idPlace:placeId,success: { (response) in
            success()
            }, failure: failure)
    }
}
