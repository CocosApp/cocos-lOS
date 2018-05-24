//
//  BaseService.swift
//  cocos
//
//  Created by MIGUEL on 21/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BaseService : NSObject {
    // MARK: - Properties
    let baseUrl = "http://cocos.cerezaconsulting.com/api/"
    
    typealias SuccessResponse = (_ response: JSON) -> Void
    typealias FailureResponse = (_ error: NSError) -> Void
    
    // MARK: - Public
    func authorizationHeader(withToken token: String) -> [String: String] {
        return ["Authorization": "Token " + token]
    }
    func authorizationAndContentTypeHeader(withToken token: String,withContentType contentType: String) -> [String: String] {
        return ["Authorization": "Token " + token, "Content-Type":contentType]
    }
    
    func validateResponse(_ response: JSON, success: SuccessResponse, failure: FailureResponse) -> Void {
        success(response)
        /*let isSuccess = response["success"].boolValue
         if isSuccess {
         success(response)
         } else {
         let errorMessage = response["error_msg"].stringValue
         let error = NSError(domain: "GLUP", code: -999, message: errorMessage)
         failure(error)
         }*/
    }
    
    func queryString(fromArray array: [AnyObject]?) -> String {
        guard let v = array else {
            return ""
        }
        var s = ""
        for i in 0 ..< v.count {
            if i > 0 && i < v.count {
                s.append(",")
            }
            s.append(v[i].description.addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: "-_.!~*'()"))!)
        }
        return s
    }
    
    func POST(withEndpoint endpoint: String, params: [String:String]?, headers: [String:String]?, success: @escaping SuccessResponse, failure: @escaping FailureResponse) -> Void {
        self.request(toURL: self.baseUrl + endpoint, withMethod: .post, params: params, headers: headers, success: success, failure: failure)
    }
    
    func GET(withEndpoint endpoint: String, params: [String:String]?, headers: [String:String]?, success: @escaping SuccessResponse, failure: @escaping FailureResponse) -> Void {
        self.request(toURL: self.baseUrl + endpoint, withMethod: .get, params: params, headers: headers, success: success, failure: failure)
    }
    
    func PUT(withEndpoint endpoint: String, params: [String:String]?, headers: [String:String]?, success: @escaping SuccessResponse, failure: @escaping FailureResponse) -> Void {
        self.request(toURL: self.baseUrl + endpoint, withMethod: .put, params: params, headers: headers, success: success, failure: failure)
    }
    
    func PATCH(withEndpoint endpoint: String, params:[String:String]?, headers: [String:String]?, success: @escaping SuccessResponse, failure: @escaping FailureResponse) -> Void {
        self.request(toURL: self.baseUrl + endpoint, withMethod: .patch, params : params, headers: headers, success: success, failure: failure)
    }
    
    func DELETE(withEndpoint endpoint: String, params:[String:String]?, headers: [String: String]?, success: @escaping SuccessResponse, failure: @escaping FailureResponse) -> Void {
        self.request(toURL: self.baseUrl + endpoint, withMethod: .delete, params: params, headers: headers, success: success, failure: failure)
    }
    
    
    func request(toURL url: String, withMethod method: HTTPMethod, params: [String: String]?, headers: [String: String]?, success: @escaping
        SuccessResponse, failure: @escaping FailureResponse) -> Void {
        print("request url -> " + url)
        var httpHeaders = [String:String]()
        if let headerParams = headers {
            httpHeaders = headerParams
        }
        httpHeaders["Content-Type"] = "application/json"
        print("request headers -> " + httpHeaders.debugDescription)
        if params != nil {
            print("request params -> ", params.debugDescription)
        }
        Alamofire.request(url, method: method, parameters: params,encoding: JSONEncoding.default, headers: httpHeaders)
            .responseString { (response) in
                print(response)
                print("Code \(String(describing: response.response?.statusCode)) ")
                if response.response?.statusCode == 200 ||
                    response.response?.statusCode == 201 ||
                    response.response?.statusCode == 202 ||
                    response.response?.statusCode == 204{
                    if let data = response.data {
                        do {
                            let json = try JSON(data: data)
                            success(json)
                        } catch let error as NSError {
                            failure(error)
                        }
                    } else {
                        success(JSON.null)
                    }
                } else {
                    var customError: NSError? = nil
                    if let error = response.result.error {
                        customError = NSError(domain: "COCOS", code: -999, userInfo:
                            [
                                NSLocalizedDescriptionKey : error.localizedDescription
                            ])
                    } else {
                        customError = NSError(domain: "COCOS", code: -999, userInfo:
                            [
                                NSLocalizedDescriptionKey: "Ocurrió un error inesperado, por favor inténtelo más tarde"
                            ])
                    }
                    failure(customError!)
                }
        }
    }
    
    
}
