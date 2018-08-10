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
    case deleteFavoritePlace = "user/favrestaurant/delete/me"
}

class FavoriteService : BaseService {
    static let sharedService = FavoriteService()
    
    func getFavoritePlaces(token:String,success: @escaping SuccessResponse,failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GET(withEndpoint: FavoriteEndpoint.favoritePlaceList.rawValue, params: nil, headers: header, success: success, failure: failure)
    }
    
    func getFavoritePlaces(token:String,endpoint:String,success: @escaping SuccessResponse,failure: @escaping FailureResponse){
        
    }
    
    func addFavoritePlace(token:String,idPlace:String,success: @escaping SuccessResponse,failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        let params = ["restaurant":idPlace]
        self.POST(withEndpoint: FavoriteEndpoint.favoritePlaceList.rawValue, params: params, headers: header, success: success, failure: failure)
    }
    
    func deleteFavoritePlace(token:String,idPlace:String,success: @escaping SuccessResponse,failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        let params = ["restaurant_id":idPlace]
        self.POST(withEndpoint: FavoriteEndpoint.deleteFavoritePlace.rawValue, params: params, headers: header, success: success, failure: failure)
    }
}
