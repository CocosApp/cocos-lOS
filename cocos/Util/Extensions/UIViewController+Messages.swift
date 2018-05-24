//
//  UIViewController+Messages.swift
//  cocos
//
//  Created by MIGUEL on 5/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import SwiftMessages

extension UIViewController {
    
    func showErrorMessage(withTitle title:String) -> Void {
        SwiftMessages.hideAll()
        let view: MessageView = try! SwiftMessages.viewFromNib(named: "ErrorMessageView")
        view.bodyLabel?.text = title
        SwiftMessages.show(view: view)
    }
    
    func showSuccessMessage(withTitle title:String) -> Void {
        SwiftMessages.hideAll()
        let view: MessageView = try! SwiftMessages.viewFromNib(named: "SuccessMessageView")
        view.bodyLabel?.text = title
        SwiftMessages.show(view: view)
    }
    
    func showErrorMessage(withTitle title:String, andFirstResponder textField:UITextField) -> Void {
        self.showErrorMessage(withTitle: title)
        textField.becomeFirstResponder()
    }
    
    func showSuccessMessage(withTitle title:String, andFirstResponder textField:UITextField) -> Void {
        self.showSuccessMessage(withTitle: title)
        textField.becomeFirstResponder()
    }
}

