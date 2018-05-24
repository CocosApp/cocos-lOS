//
//  PlaceDetailService.swift
//  cocos
//
//  Created by MIGUEL on 7/05/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import Foundation

enum PlaceDetailEndpoint : String {
    case detail = "restaurant/RUD/<pk>/"
}

class PlaceDetailService : BaseService {
    static let service = PlaceDetailService()
    
    func getPlaceDetail(_ token:String, placeId:String, success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let headers = authorizationHeader(withToken: token)
        self.GET(withEndpoint: PlaceDetailEndpoint.detail.rawValue.replacingOccurrences(of: "<pk>", with: placeId), params: nil, headers: headers, success: success, failure: failure)
    }
}
