//
//  SearchPlaceController.swift
//  cocos
//
//  Created by MIGUEL on 22/04/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class SearchPlaceController : NSObject {
    static let controller = SearchPlaceController()
    
    var list : ResponseEntityPlaces!
    
    func searchPlace(success: @escaping (_ places : [PlacesEntity])->Void,failure : @escaping (_ error : NSError)->Void){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        PlacesService.sharedService.getPlaceList(token: user.token, success: { (response) in
            self.list = ResponseEntityPlaces.getResponseFromJSON(fromJSON: response)
            success(self.list.results)
        }, failure: failure)
    }
    
    func searchNextPlace(success: @escaping(_ places : [PlacesEntity])->Void,failure : @escaping (_ error: NSError)->Void){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        if list.next != nil && list.next != ""{
                PlacesService.sharedService.getPlaceList(token: user.token, endpoint: list.next!, success: { (response) in
                    self.list = ResponseEntityPlaces.getResponseFromJSON(fromJSON: response)
                    success(self.list.results)
                }, failure: failure)
        }
    }
    
    func searchPlace(text : String , success: @escaping (_ places : [PlacesEntity])->Void, failure : @escaping (_ error:NSError)->Void){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        PlacesService.sharedService.getSearchPlaces(token: user.token,search:text, success: { (response) in
            self.list = ResponseEntityPlaces.getResponseFromJSON(fromJSON: response)
            success(self.list.results)
        }, failure: failure)
    }
}
