//
//  AboutViewController.swift
//  cocos
//
//  Created by MIGUEL on 22/04/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class AboutViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func communicateWithUsDidSelect(_ sender: UIButton) {
        UIApplication.shared.open(URL(string : "http://appcocos.com")!, options: [:], completionHandler: { (status) in
            
        })
    }
    @IBAction func workWithUsDidSelect(_ sender: UIButton) {
        UIApplication.shared.open(URL(string : "http://appcocos.com/auth/signup")!, options: [:], completionHandler: { (status) in
            
        })
    }
}
