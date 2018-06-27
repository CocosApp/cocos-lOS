//
//  CarPopUp.swift
//  cocos
//
//  Created by MIGUEL on 27/06/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class CarPopUp : UIViewController {
    
    @IBAction func uberButtonDidSelect(_ sender: UIButton) {
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
