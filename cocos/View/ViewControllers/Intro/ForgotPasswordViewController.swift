//
//  ForgotPasswordViewController.swift
//  cocos
//
//  Created by MIGUEL on 5/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import Foundation
import UIKit


class ForgotPasswordViewController : BaseUIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBAction func forgotPasswordDidSelect(_ sender: UIButton) {
        let email = emailTextField.text!
        let confirmEmail = confirmEmailTextField.text!
        let isValid = Utils.isValidEmail(testStr: email)
        if isValid {
            if (email.elementsEqual(confirmEmail) ){
                self.showActivityIndicator()
                let service = AuthorizationService.sharedService
                service.recoverPassword(email: email, success: { detail in
                    self.hideActivityIndicator()
                    self.showSuccessMessage(withTitle: "Se le enviará un correo")
                }, failure: { (error) in
                    self.hideActivityIndicator()
                    self.showErrorMessage(withTitle: error.localizedDescription)
                })
            }
            else{
               self.showErrorMessage(withTitle: "Correo no coincide")
            }
        }
        else{
            self.showErrorMessage(withTitle: "Formato de correo no válido")
        }
    }
    
}
