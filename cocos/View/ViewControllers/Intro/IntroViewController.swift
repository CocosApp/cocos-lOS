//
//  IntroViewController.swift
//  cocos
//
//  Created by MIGUEL on 5/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class IntroViewController : BaseUIViewController {
    @IBOutlet weak var viewPager: ViewPager!
    
    let descriptionLabels = ["Los mejores descuentos cerca a tu ubicación.","Y comparte los descuentos."]
    let descriptionImages = [#imageLiteral(resourceName: "descubre"),#imageLiteral(resourceName: "disfruta")]
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        viewPager.dataSource = self
        viewPager.animationNext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewPager.scrollToPage(0)
    }
    
    @IBAction func skipButtonDidSelect(_ sender: Any) {
        
    }
    
}

extension IntroViewController : ViewPagerDataSource{
    
    func numberOfItems(_ viewPager: ViewPager) -> Int {
        return 2
    }
    
    func viewAtIndex(_ viewPager: ViewPager, index: Int, view: UIView?) -> UIView {
        var newView = view
        var itemView = Bundle.main.loadNibNamed("IntroCustomView", owner: self, options: nil)?.first as! ItemViewPager
        if newView ==  nil {
            newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:  self.view.frame.height))
            itemView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:  self.view.frame.height)
            itemView.tag = 1
            newView?.addSubview(itemView)
        }
        else{
            itemView = newView?.viewWithTag(1) as! ItemViewPager
        }
        itemView.imageItem.image = descriptionImages[index]
        itemView.descriptionItem.text = descriptionLabels[index]
        return newView!
    }
}
