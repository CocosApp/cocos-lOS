//
//  CarPopUp.swift
//  cocos
//
//  Created by MIGUEL on 27/06/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import Firebase

class CarPopUp : UIViewController {
    
    var placeSelected: PlaceDetailEntity!
    var user: UserEntity!
    
    @IBAction func uberButtonDidSelect(_ sender: UIButton) {
        //Analytics
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let actualDate = formatter.string(from: date)
        let params = ["id_restaurant":placeSelected.id,"name_restaurant":placeSelected.name,"id_user":user.id,"name_user":user.fullName,"date":actualDate,"label":"take_uber","so":"ios"] as [String:Any]
        Analytics.logEvent("take_uber", parameters: params)
        
        if let url = URL(string: "uber://?action=setPickup")
        {
            if UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                
                if UIApplication.shared.canOpenURL(URL(string: "https://itunes.apple.com/us/app/uber/id368677368")!) {
                    UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/uber/id368677368")!, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @IBAction func cabifyButtonDidSelect(_ sender: UIButton) {
        //Analytics
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let actualDate = formatter.string(from: date)
        let params = ["id_restaurant":placeSelected.id,"name_restaurant":placeSelected.name,"id_user":user.id,"name_user":user.fullName,"date":actualDate,"label":"take_cabify"] as [String:Any]
        Analytics.logEvent("take_cabify", parameters: params)
        
        if let url = URL(string: "cabify://cabify")
        {
            if UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                
                if UIApplication.shared.canOpenURL(URL(string: "https://itunes.apple.com/us/app/cabify/id476087442")!) {
                    UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/cabify/id476087442")!, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @IBAction func cancelButtonDidSelect(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
