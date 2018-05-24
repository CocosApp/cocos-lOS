//
//  BaseableController.swift
//  cocos
//
//  Created by MIGUEL on 5/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

protocol BaseableController {
    func baseSetup() -> Void
}

extension BaseableController where Self: UIViewController {
    func baseSetup() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension BaseableController where Self: UITableViewController {
    func baseSetup() {
        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension BaseableController where Self: UICollectionViewController {
    func baseSetup() {
        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
