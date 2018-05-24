//
//  UserEntity.swift
//  cocos
//
//  Created by MIGUEL on 21/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserEntity : NSObject, NSCoding {
    //MARK: - Constants
    static let kStoredUserKey:String = "CurrentUser"
    
    //MARK: - Properties
    var id : Int = 0
    var email : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var birthday : String = ""
    var picture : String = ""
    var token : String = ""
    
    var fullName:String{
        var fullName = ""
        if(self.firstName != "" && self.lastName != ""){
            fullName = "\(self.firstName) \(self.lastName)"
        }
        return fullName
    }
    
    // MARK: - Constructors
    override init() {
        super.init()
    }
    
    //MARK: - Public
    func copyFromJSON(_ json: JSON){
        guard let body = json as JSON? else {
            return
        }
        self.id = body["id"].intValue
        self.email = body["email"].stringValue
        self.firstName = body["first_name"].stringValue
        self.lastName = body["last_name"].stringValue
        self.birthday = body["birthday"].stringValue
        self.picture = body["picture"].stringValue
    }
    
    func archiveUser() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: UserEntity.kStoredUserKey)
        UserDefaults.standard.synchronize()
    }
    
    class func unarchiveUser() {
        UserDefaults.standard.removeObject(forKey: UserEntity.kStoredUserKey)
        UserDefaults.standard.synchronize()
    }
    
    class func retriveArchiveUser() -> UserEntity? {
        guard let data = UserDefaults.standard.object(forKey: UserEntity.kStoredUserKey) as? Data else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? UserEntity
    }
    
    
    //MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey : "id") as? Int ?? 0
        self.token = aDecoder.decodeObject(forKey : "token") as? String ?? ""
        self.firstName = aDecoder.decodeObject(forKey : "firstName") as? String ?? ""
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey:"email") as? String ?? ""
        self.picture = aDecoder.decodeObject(forKey:"picture") as? String ?? ""
        self.birthday = aDecoder.decodeObject(forKey: "birthday") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id,forKey:"id")
        aCoder.encode(self.token,forKey:"token")
        aCoder.encode(self.firstName,forKey : "firstName")
        aCoder.encode(self.lastName,forKey: "lastName")
        aCoder.encode(self.email,forKey:"email")
        aCoder.encode(self.picture,forKey:"picture")
        aCoder.encode(self.birthday,forKey:"birthday")
    }
    
}
