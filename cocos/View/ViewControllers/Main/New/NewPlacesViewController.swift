//
//  NewPlacesViewController.swift
//  cocos
//
//  Created by MIGUEL on 7/08/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import Firebase

class NewPlacesViewController: BaseUIViewController {
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var nearMeButton: UIButton!
    @IBOutlet weak var benefitButton: UIButton!
    
    var containerView : ContainerViewController!
    var buttonSelected : PlacesButtonSelected = .category
    let kshowCategoryIdentifier : String = "showCategoryIdentifier"
    let kshowNearMeIdentifier : String = "showNearMeIdentifier"
    let kshowBenefitsIdentifier : String = "showBenefitsIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectButton(buttonSelected)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func searchButtonDidSelect(_ sender: Any) {
        performSegue(withIdentifier: "showSearchIdentifier", sender: self)
    }
    
    @IBAction func categoryButtonDidSelect(_ sender: Any) {
        selectButton(PlacesButtonSelected.category)
        //Analytics
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let actualDate = formatter.string(from: date)
        let params = ["date":actualDate,"label":"category_button","so":"ios"] as [String:Any]
        Analytics.logEvent("category_button", parameters: params)
        
    }
    
    @IBAction func nearMeButtonDidSelect(_ sender: Any) {
        selectButton(PlacesButtonSelected.nearMe)
        //Analytics
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let actualDate = formatter.string(from: date)
        let params = ["date":actualDate,"label":"near_me_button","so":"ios"] as [String:Any]
        Analytics.logEvent("near_me_button", parameters: params)
        
    }
    
    @IBAction func benefitButtonDidSelect(_ sender: Any) {
        selectButton(PlacesButtonSelected.discount)
        //Analytics
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let actualDate = formatter.string(from: date)
        let params = ["date":actualDate,"label":"benefit_button","so":"ios"] as [String:Any]
        Analytics.logEvent("benefit_button", parameters: params)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container"{
            containerView = segue.destination as! ContainerViewController
            containerView.animationDurationWithOptions = (0.2, .transitionCrossDissolve)
        }
    }
    
    fileprivate func changeColor(_ button : UIButton,_ type: Bool){
        if type {
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = button.bounds
            gradient.colors = [
                UIColor(red:255/255,green:255/255,blue:255/255,alpha:1).cgColor,
                UIColor(red:255/255,green:255/255,blue:255/255,alpha:1).cgColor,
                UIColor(red:211/255,green:211/255,blue:211/255,alpha:1).cgColor,
                UIColor(red:211/255,green:211/255,blue:211/255,alpha:1).cgColor
            ]
            
            /* repeat the central location to have solid colors */
            gradient.locations = [0, 0.9, 0.9, 1.0]
            
            /* make it vertical */
            gradient.startPoint = CGPoint(x:0.5,y: 0)
            gradient.endPoint = CGPoint(x:0.5,y: 1)
            
            button.layer.insertSublayer(gradient, at: 0)
        }
        else{
            if let layers = button.layer.sublayers{
                if layers.count>1{
                    layers[0].removeFromSuperlayer()
                }
            }
            button.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha:1)
        }
    }
    
    fileprivate func selectButton(_ typeButton : PlacesButtonSelected){
        switch typeButton {
        case .category:
            buttonSelected = PlacesButtonSelected.category
            changeColor(categoryButton, true)
            changeColor(nearMeButton, false)
            changeColor(benefitButton, false)
            containerView.segueIdentifierReceivedFromParent(kshowCategoryIdentifier)
            break
        case .nearMe:
            buttonSelected = PlacesButtonSelected.nearMe
            changeColor(categoryButton, false)
            changeColor(nearMeButton, true)
            changeColor(benefitButton, false)
            containerView.segueIdentifierReceivedFromParent(kshowNearMeIdentifier)
            break
        case .discount:
            buttonSelected = PlacesButtonSelected.discount
            changeColor(categoryButton, false)
            changeColor(nearMeButton, false)
            changeColor(benefitButton, true)
            containerView.segueIdentifierReceivedFromParent(kshowBenefitsIdentifier)
            break
        }
    }
}
