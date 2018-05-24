//
//  LoginController.swift
//  cocos
//
//  Created by MIGUEL on 21/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginController: NSObject {
    static let controller = LoginController()
    var currentUser:UserEntity?

    //MARK: - Constructor
    override init() {
        super.init()
        self.currentUser = UserEntity.retriveArchiveUser()
    }
    
    func login(email:String, password:String, success: @escaping (_ user: UserEntity) -> Void , failure: @escaping (_ error : NSError) -> Void){
        let service = AuthorizationService.sharedService
        service.login(email: email, password: password, success: { (response: JSON) -> Void in
            let user = UserEntity()
            user.token = response["token"].stringValue
            service.userRetrieve(user.token, success: { (userResponse:JSON)->Void in
                user.copyFromJSON(userResponse)
                self.currentUser = user
                self.currentUser?.archiveUser()
                success(self.currentUser!)
                }, failure: failure)
            }, failure: failure)
    }
    
    func recoverPassword(email:String, success: @escaping (_ detail:String) -> Void, failure: @escaping (_ error:NSError) -> Void){
        let service = AuthorizationService.sharedService
        service.recoverPassword(email: email, success: { (response:JSON)->Void in
            success(response["detail"].stringValue)
            }, failure: failure)
    }
    
}
