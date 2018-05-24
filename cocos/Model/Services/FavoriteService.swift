//
//  FavoriteService.swift
//  cocos
//
//  Created by MIGUEL on 21/04/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import Foundation

enum FavoriteEndpoint : String {
    case favoritePlaceList = "favrestaurants/me/"
}

class FavoriteService : BaseService {
    static let sharedService = FavoriteService()
    
    func getFavoritePlaces(token:String,success: @escaping SuccessResponse,failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GET(withEndpoint: FavoriteEndpoint.favoritePlaceList.rawValue, params: nil, headers: header, success: success, failure: failure)
    }
}
