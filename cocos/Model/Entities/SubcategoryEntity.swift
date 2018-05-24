//
//  SubcategoryENtity.swift
//  cocos
//
//  Created by MIGUEL on 8/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class SubcategoryEntity : NSObject {
    var id: Int = 0
    var name: String = ""
    var descriptionLabel: String = ""
    var image : String = ""
    
    class func getSubcategoriesFromJSONArray(fromJSONArray jsonArray : [JSON]?)->[SubcategoryEntity]? {
        var subcategories : [SubcategoryEntity] = []
        if let data = jsonArray{
            for json in data {
                subcategories.append(SubcategoryEntity.getSubcategoryFromJSON(fromJSON: json)!)
            }
        }
        return subcategories
    }
    
    class func getSubcategoryFromJSON(fromJSON json : JSON?)->SubcategoryEntity? {
        if let data = json {
            let subcategory = SubcategoryEntity()
            subcategory.id = data["id"].intValue
            subcategory.name = data["name"].stringValue
            subcategory.descriptionLabel = data["description"].stringValue
            subcategory.image = data["image"].stringValue
            return subcategory
        }
        return nil
    }
}
