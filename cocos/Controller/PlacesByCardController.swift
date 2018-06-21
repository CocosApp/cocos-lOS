//
//  PlacesByCardController.swift
//  cocos
//
//  Created by MIGUEL on 21/06/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import Foundation

class PlacesByCardController: NSObject {
    static let controller = PlacesByCardController()
    
    func getList(cardId:String,success : @escaping (_ response : [PlacesEntity]) -> Void, failure : @escaping (_ error:NSError) -> Void){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        PlacesService.sharedService.getPlacesByCard(token: user.token, cardId: cardId, success: { (response) in
            let entity = ResponseEntityCardPlaces.getResponseFromJSON(fromJSON: response)
            let placesFromCards = self.getPlacesFromCards(cards: (entity?.results)!)
            success(placesFromCards!)
        }, failure: failure)
    }
    
    fileprivate func getPlacesFromCards(cards:[CardPlacesEntity]) -> [PlacesEntity]?{
        var places : [PlacesEntity] = []
        for entity in cards {
            places.append(contentsOf: entity.places)
        }
        return places
    }
}
