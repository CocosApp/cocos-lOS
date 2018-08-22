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
    var placeDetailDelegate : ErrorMessageDelegate!
    var placeDetail = PlaceDetailEntity(){
        didSet{
            self.setup()
        }
    }
    func setup(){
        locationLabel.text = placeDetail.address
        if placeDetail.schedule.count>0{
            timeServiceLabel.text = placeDetail.schedule[0].name
        }
        phoneLabel.text = placeDetail.mobile
        facebookLink = placeDetail.facebook
        whatsAppNumber = placeDetail.whatsapp
        timeServiceLabel.text = placeDetail.getScheduleText()
        for service in placeDetail.service{
            self.setupServices(service:service)
        }
    }
    
    func setupServices(service:ServicesEntity){
        switch service.name {
        case "Aire acondicionado":
           airServiceIcon.image = #imageLiteral(resourceName: "air-icon-on")
        case "Bar":
           drinkServiceIcon.image = #imageLiteral(resourceName: "drink-icon-on")
        case "Estacionamiento":
           parkingServiceIcon.image = #imageLiteral(resourceName: "parking-icon-on")
        case "Servicios para discapacitados":
           handicapServiceIcon.image = #imageLiteral(resourceName: "handicap-icon-on")
        case "Valet Parking":
           valetParkingServiceIcon.image = #imageLiteral(resourceName: "valet-parking-icon-on")
        case "Wi-Fi":
           wifiServiceIcon.image = #imageLiteral(resourceName: "wifi-icon-on")
        default:
            break
        }
    }
    
    @IBAction func getFacebookLink(_ sender:UIButton){
        if let facebookUrl = URL(string: facebookLink){
            if UIApplication.shared.canOpenURL(facebookUrl){
                UIApplication.shared.open(facebookUrl, options: [:], completionHandler: nil)
            }
        }
        else {
            if UIApplication.shared.canOpenURL(URL(string: "https://itunes.apple.com/pe/app/facebook/id284882215")!) {
                UIApplication.shared.open(URL(string: "https://itunes.apple.com/pe/app/facebook/id284882215")!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func getWhatsappLink(_ sender:UIButton){
        if let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=\(whatsAppNumber)&text=Invitation"){
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL,options:[:],completionHandler:nil)
            }
            else {
                if UIApplication.shared.canOpenURL(URL(string: "https://itunes.apple.com/pe/app/whatsapp-messenger/id310633997")!) {
                    UIApplication.shared.open(URL(string: "https://itunes.apple.com/pe/app/whatsapp-messenger/id310633997")!, options: [:], completionHandler: nil)
                }
            }
        }
        else {
            self.placeDetailDelegate.withError(error: "Este lugar no posee número de whastapp")
        }
    }
    
    @IBAction func getLocationMap(_ sender:UIButton){
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?saddr=&daddr=\(placeDetail.latitude),\(placeDetail.longitude)&directionsmode=driving")!, options: [:], completionHandler: nil)
        } else {
            if UIApplication.shared.canOpenURL(URL(string: "https://itunes.apple.com/pe/app/google-maps/id585027354")!) {
                UIApplication.shared.open(URL(string: "https://itunes.apple.com/pe/app/google-maps/id585027354")!, options: [:], completionHandler: nil)
            }
        }
    
    }
    
    @IBAction func downloadMenuPDFButtonDidSelect(_ sender: Any) {
        if placeDetail.food_letter != "" {
            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
            docURL = docURL?.appendingPathComponent("\(placeDetail.food_letter).pdf") as NSURL?
            let url = URL.init(string: placeDetail.food_letter)
            Downloader.load(url: url!, to: docURL! as URL) {
                self.placeDetailDelegate.withError(error: "Descarga exitosa")
            }
        }
        else {
            self.placeDetailDelegate.withMessage(message: "No hay carta disponible")
        }
    }
    
}
