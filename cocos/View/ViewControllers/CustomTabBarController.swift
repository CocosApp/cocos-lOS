//
//  CustomTabBarController.swift
//  cocos
//
//  Created by MIGUEL on 27/06/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class CustomTabBarController : UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for item in self.tabBar.items! {
            item.image = item.selectedImage!.withRenderingMode(.alwaysOriginal)
        }
    }
}
