//
//  RegisterController.swift
//  cocos
//
//  Created by MIGUEL on 5/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import Foundation
import SwiftyJSON

class RegisterController: NSObject{
    static let controller = RegisterController()
    var currentUser : UserEntity?
    
    //MARK: - Constructor
    override init() {
        super.init()
        self.currentUser = UserEntity.retriveArchiveUser()
    }
    
    func register(email:String,password:String,firstName:String,lastName:String,success: @escaping (_ user: UserEntity)->Void,failure:@escaping (_ error:NSError)->Void){
        let service = AuthorizationService.sharedService
        
        service.register(email: email, password: password, firstName: firstName, lastName: lastName, success: { (response:JSON)->Void in
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
}
