//
//  ItemViewPager.swift
//  cocos
//
//  Created by MIGUEL on 6/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class ItemViewPager : UIView {
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var descriptionItem: UILabel!
    
    var view : UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func xibSetUp() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() ->UIView {
        let view = Bundle.main.loadNibNamed("IntroCustomView", owner: self, options: nil)?.first as! UIView
        return view
    }
}
