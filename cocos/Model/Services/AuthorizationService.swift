//
//  LoginService.swift
//  cocos
//
//  Created by MIGUEL on 21/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import Foundation

enum AuthorizationEndpoints : String {
    case login = "login/"
    case register = "register/"
    case userRetrieve = "user/retrieve/"
    case recoveryPassword = "recovery/"
    case loginFacebook = "login/mobile/facebook/"
    case loginGmail = "login/mobile/gmail/"
}

class AuthorizationService : BaseService {
    //MARK: - Properties
    static let sharedService = AuthorizationService()
    
    //MARK: - Public
    func login(email:String, password:String, success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let params = ["email":email,"password":password]
        self.POST(withEndpoint: AuthorizationEndpoints.login.rawValue, params: params, headers: nil, success: success, failure: failure)
    }
    
    func userRetrieve(_ token:String, success: @escaping SuccessResponse,failure: @escaping FailureResponse){
        let headers = authorizationHeader(withToken: token)
        self.GET(withEndpoint: AuthorizationEndpoints.userRetrieve.rawValue, params: nil, headers: headers, success: success, failure: failure)
    }
    
    func register(email:String, password:String, firstName:String, lastName:String, success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let params = ["email":email,"password":password,"first_name":firstName,"last_name":lastName]
        self.POST(withEndpoint: AuthorizationEndpoints.register.rawValue, params: params, headers: nil, success: success, failure: failure)
    }
    
    func recoverPassword(email:String, success: @escaping SuccessResponse, failure: @escaping FailureResponse){
        let params = ["email":email]
        self.POST(withEndpoint: AuthorizationEndpoints.recoveryPassword.rawValue, params: params, headers: nil, success: success, failure: failure)
    }
    
}
