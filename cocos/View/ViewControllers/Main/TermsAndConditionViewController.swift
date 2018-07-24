//
//  TermsAndConditionViewController.swift
//  cocos
//
//  Created by MIGUEL on 24/07/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class TermsAndConditionViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    var termsAndConditions: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionLabel.text = termsAndConditions
    }

    @IBAction func closeButtonDidSelect(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
