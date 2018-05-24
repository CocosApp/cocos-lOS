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
    
    func searchPlace(success: @escaping (_ places : [PlacesEntity])->Void,failure : @escaping (_ error : NSError)->Void){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        PlacesService.sharedService.getPlaceList(token: user.token, success: { (response) in
            let list = ResponseEntityPlaces.getResponseFromJSON(fromJSON: response)
            success((list?.results)!)
        }, failure: failure)
    }
}
