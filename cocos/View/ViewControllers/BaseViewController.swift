//
//  BaseViewController.swift
//  cocos
//
//  Created by MIGUEL on 5/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class BaseUIViewController : UIViewController , BaseableController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseSetup()
    }
    
    func requestDidFinishWithError(_ error: NSError) {
        self.hideActivityIndicator()
        self.showErrorMessage(withTitle: error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func presentMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateInitialViewController()!
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        
        UIView.transition(from: (window?.rootViewController?.view!)!, to: viewController.view!, duration: 0.5, options: .transitionFlipFromRight, completion:{ finish in
            if finish == true {
                window?.rootViewController = viewController
            }
        })
    }
    
}
