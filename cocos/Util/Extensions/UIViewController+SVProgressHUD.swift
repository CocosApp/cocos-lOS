//
//  UIViewController+SVProgressHUD.swift
//  cocos
//
//  Created by MIGUEL on 5/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    
    func showActivityIndicator() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async(execute: {
            SVProgressHUD.dismiss()
        })
    }
    
}
