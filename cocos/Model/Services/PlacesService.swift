//
//  PlacesService.swift
//  cocos
//
//  Created by MIGUEL on 8/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import Foundation

enum PlacesEndpoints: String {
    case placeSubcategoryList = "subcategory/list"
    case placesList = "restaurant/list/"
    case placesByGPS = "restaurantGPS/list/?lat=<lt>&long=<lng>&rad=5"
    case cardList = "card/list/"
    case placesBySubcategory = "restaurantBySubcategory/<pk>/list/"
    case placesByCard = "card/<pk>/discount/restaurant"
    case placesSearch = "restaurant/list/?search=<search>"
}

class PlacesService : BaseService {
    //MARK: - Properties
    static let sharedService = PlacesService()
    
    //MARK: - Public
    func getPlaceList(token: String,success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GET(withEndpoint: PlacesEndpoints.placesList.rawValue, params: nil, headers: header, success: success, failure: failure)
    }
    
    func getPlaceList(token: String,endpoint:String,success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GETPagination(withEndpoint: endpoint.replacingOccurrences(of: "http", with: "https"), params: nil, headers: header, success: success, failure: failure)
    }
    
    func getSubcategoryList(token: String,success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GET(withEndpoint: PlacesEndpoints.placeSubcategoryList.rawValue, params: nil, headers: header, success: success, failure: failure)
    }
    
    func getSubcategoryList(token: String,endpoint:String ,success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GETPagination(withEndpoint: endpoint.replacingOccurrences(of: "http", with: "https"), params: nil, headers: header, success: success, failure: failure)
    }
    
    func getPlacesByGPS(token:String,lat:String,long:String,success:@escaping SuccessResponse, failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GET(withEndpoint: PlacesEndpoints.placesByGPS.rawValue.replacingOccurrences(of: "<lt>", with: lat).replacingOccurrences(of: "<lng>", with: long), params: nil, headers: header, success: success, failure: failure)
    }
    
    func getPlacesByGPS(token:String,lat:String,long:String,endpoint:String,success:@escaping SuccessResponse, failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GETPagination(withEndpoint: endpoint.replacingOccurrences(of: "http", with: "https"), params: nil, headers: header, success: success, failure: failure)
    }
    
    func getDiscountList(token:String,endpoint:String,success: @escaping SuccessResponse,failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GETPagination(withEndpoint: endpoint.replacingOccurrences(of: "http", with: "https"), params: nil, headers: header, success: success, failure: failure)
    }
    
    func getDiscountList(token:String,success: @escaping SuccessResponse,failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GET(withEndpoint: PlacesEndpoints.cardList.rawValue, params: nil, headers: header, success: success, failure: failure)
    }
    
    func getPlacesBySubcategory(token:String,subcategoryId:String,success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GET(withEndpoint: PlacesEndpoints.placesBySubcategory.rawValue.replacingOccurrences(of: "<pk>", with: subcategoryId), params: nil, headers: header, success: success, failure: failure)
    }
    
    func getPlacesBySubcategory(token:String,endpoint:String,success: @escaping SuccessResponse,failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GETPagination(withEndpoint: endpoint.replacingOccurrences(of: "http", with: "https"), params: nil, headers: header, success: success, failure: failure)
    }
    
    func getPlacesByCard(token:String,cardId:String,success: @escaping SuccessResponse,failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GET(withEndpoint: PlacesEndpoints.placesByCard.rawValue.replacingOccurrences(of: "<pk>", with: cardId), params: nil, headers: header, success: success, failure: failure)
    }
    
    func getSearchPlaces(token:String, search:String,success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GET(withEndpoint: PlacesEndpoints.placesSearch.rawValue.replacingOccurrences(of: "<search>", with: search), params: nil, headers: header, success: success, failure: failure)
    }
    
    func getNextSearchPlaces(token:String, endpoint:String,success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let header = authorizationHeader(withToken: token)
        self.GETPagination(withEndpoint: endpoint.replacingOccurrences(of: "http", with: "https"), params: nil, headers: header, success: success, failure: failure)
    }

}
