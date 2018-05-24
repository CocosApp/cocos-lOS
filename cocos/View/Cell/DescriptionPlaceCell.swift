//
//  DescriptionPlaceCell.swift
//  cocos
//
//  Created by MIGUEL on 7/05/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class DescriptionPlaceCell : UITableViewCell{
    @IBOutlet weak var wifiServiceIcon : UIImageView!
    @IBOutlet weak var airServiceIcon : UIImageView!
    @IBOutlet weak var drinkServiceIcon : UIImageView!
    @IBOutlet weak var handicapServiceIcon : UIImageView!
    @IBOutlet weak var parkingServiceIcon : UIImageView!
    @IBOutlet weak var valetParkingServiceIcon : UIImageView!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var timeServiceLabel : UILabel!
    @IBOutlet weak var phoneLabel : UILabel!
    var facebookLink : String!
    var whatsAppNumber : String!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var placeDetail = PlaceDetailEntity(){
        didSet{
            self.setup()
        }
    }
    func setup(){
        locationLabel.text = placeDetail.address
        if placeDetail.schedule != nil && placeDetail.schedule.count>0{
            timeServiceLabel.text = placeDetail.schedule[0].name
        }
        phoneLabel.text = placeDetail.mobile
        facebookLink = placeDetail.facebook
        whatsAppNumber = placeDetail.whatsapp
    }
    
    @IBAction func getFacebookLink(_ sender:UIButton){
        UIApplication.shared.open(URL(string: facebookLink)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func getWhatsappLink(_ sender:UIButton){
        let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=\(whatsAppNumber)&text=Invitation")
        if UIApplication.shared.canOpenURL(whatsappURL!) {
            UIApplication.shared.open(whatsappURL!,options:[:],completionHandler:nil)
        }
    }
    
    @IBAction func getLocationMap(_ sender:UIButton){
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?saddr=&daddr=\(placeDetail.latitude),\(placeDetail.longitude)&directionsmode=driving")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://");
        }
    
    }
}
