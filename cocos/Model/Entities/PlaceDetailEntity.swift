//
//  PlaceDetailEntity.swift
//  cocos
//
//  Created by MIGUEL on 7/05/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import SwiftyJSON

class PlaceDetailEntity : NSObject {
    var id : String!
    var name : String!
    var ruc : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var schedule: [ScheduleEntity]=[]
    var address : String = ""
    var whatsapp : String = ""
    var facebook : String = ""
    var food_letter : String = ""
    var mobile : String = ""
    var photo1 : String?
    var photo2 : String?
    var photo3 : String?
    var discount : [PromotionEntity] = []
    var service : [ServicesEntity] = []
    
    
    class func getDetailFromJSON(fromJSON json : JSON?)-> PlaceDetailEntity?{
        guard let data = json else{
            return nil
        }
        let place = PlaceDetailEntity()
        place.id = data["id"].stringValue
        place.name = data["name"].stringValue
        place.ruc = data["ruc"].stringValue
        place.latitude = data["latitude"].doubleValue
        place.longitude = data["longitude"].doubleValue
        place.address = data["address"].stringValue
        place.whatsapp = data["whatsapp"].stringValue
        place.facebook = data["facebook"].stringValue
        place.food_letter = data["food_letter"].stringValue
        place.mobile = data["mobile"].stringValue
        place.photo1 = data["photo1"].stringValue
        place.photo2 = data["photo2"].stringValue
        place.photo3 = data["photo3"].stringValue
        place.schedule = ScheduleEntity.getListFromJSON(fromArray: data["schedule"].array)!
        place.discount = PromotionEntity.getListFromJSON(fromArray: data["discount"].array)!
        place.service = ServicesEntity.getListFromJSON(fromArray: data["service"].array)!
        return place
    }
    
    func getShareText()->String {
        var text : String = ""
        if discount.count>0{
            text = "Conoce los descuentos de"
            for discounts in discount {
                let name : String = discounts.name
                if discounts.porc>0{
                    text = "\(text) \(name) de \(discounts.porc)%"
                }else if discounts.price>0{
                    text = "\(text) \(name) de S/.\(discounts.price)"
                }
                else{
                    text = "\(text) \(name) de \(discounts.promotion)"
                }
            }
        }
        else{
            text = "Todos los descuentos en un solo sito"
        }
        return text
    }
    
    func getScheduleText() -> String{
        var text : String = ""
        if schedule.count > 0 {
            text = schedule[0].name
        }
        else{
            text = "Sin horario registrado"
        }
        return text
    }
}

class ScheduleEntity : NSObject {
    var id : String!
    var name : String!
    
    class func getListFromJSON(fromArray jsonArray: [JSON]?) -> [ScheduleEntity]?{
        var discount : [ScheduleEntity] = []
        if let data = jsonArray {
            for json in data {
                discount.append(self.getDetailFromJSON(fromJSON: json)!)
            }
        }
        return discount
    }
    
    class func getDetailFromJSON(fromJSON json : JSON?)-> ScheduleEntity?{
        guard let data = json else{
            return nil
        }
        let schedule = ScheduleEntity()
        schedule.id = data["id"].stringValue
        schedule.name = data["name"].stringValue
        return schedule
    }
}

class PromotionEntity : NSObject {
    var id : String!
    var name : String!
    var card : CardEntity?
    var porc : Float = 0
    var price : Float = 0
    var promotion : String!
    var photo : String!
    var descrip : String!
    var terms_condition : String!
    
    class func getListFromJSON(fromArray jsonArray : [JSON]?) -> [PromotionEntity]?{
        var discount : [PromotionEntity] = []
        if let data = jsonArray {
            for json in data {
                discount.append(self.getDetailFromJSON(fromJSON: json)!)
            }
        }
        return discount
    }
    
    class func getDetailFromJSON(fromJSON json : JSON?)->PromotionEntity?{
        guard let data = json else {
            return nil
        }
        let discount = PromotionEntity()
        discount.id = data["id"].stringValue
        discount.name = data["name"].stringValue
        discount.porc = data["porc"].floatValue
        discount.price = data["price"].floatValue
        discount.card = CardEntity.getCardFromJSON(fromJSON: data["card"])
        discount.promotion = data["promotion"].stringValue
        discount.terms_condition = data["terms_condition"].stringValue
        discount.descrip = data["descrip"].stringValue
        discount.photo = data["photo"].stringValue
        return discount
    }
}

class ServicesEntity : NSObject{
    var id : Int!
    var name : String!
    
    class func getListFromJSON(fromArray jsonArray : [JSON]?) -> [ServicesEntity]?{
        var services : [ServicesEntity] = []
        if let data = jsonArray {
            for json in data {
                services.append(self.getDetailFromJSON(fromJSON: json)!)
            }
        }
        return services
    }
    
    class func getDetailFromJSON(fromJSON json : JSON?)->ServicesEntity?{
        guard let data = json else{
            return nil
        }
        let service = ServicesEntity()
        service.id = data["id"].intValue
        service.name = data["name"].stringValue
        return service
    }
    
}
