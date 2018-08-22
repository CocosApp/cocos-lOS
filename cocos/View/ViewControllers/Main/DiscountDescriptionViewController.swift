//
//  DiscountDescriptionViewController.swift
//  cocos
//
//  Created by MIGUEL on 24/07/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class DiscountDescriptionViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountTitleLabel: UILabel!
    @IBOutlet weak var discountDescriptionLabel: UILabel!
    
    var promotion : PromotionEntity!
    var templateImage : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        let price : Float = promotion.price
        self.priceLabel.text = "S/.\(price)"
        self.discountTitleLabel.text = promotion.name.uppercased()
        self.discountDescriptionLabel.text = promotion.descrip
        if promotion.photo != "" {
            self.backgroundImageView.af_setImage(withURL: URL(string:promotion.photo)!)
        }
        else {
            self.backgroundImageView.af_setImage(withURL: URL(string:templateImage)!)
        }
    }

    @IBAction func termsAndConditionsButtonDidSelect(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.termsAndConditions = promotion.terms_condition
        self.present(customAlert, animated: true, completion: nil)
    }
    
}
