//
//  RegisterViewController.swift
//  cocos
//
//  Created by MIGUEL on 21/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController : BaseUIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBAction func passwordButtonDidSelect(_ sender: UIButton) {
        self.showSecurityEntry(textField: passwordTextField)
    }
    @IBAction func confirmPasswordButtonDidSelect(_ sender: UIButton) {
        self.showSecurityEntry(textField: confirmPasswordTextField)
    }
    
    @IBAction func createAccountDidSelect(_ sender: UIButton) {
        let name : String = nameTextField.text!
        let lastName : String = lastNameTextField.text!
        let email : String = emailTextField.text!
        let password : String = passwordTextField.text!
        let confirmPassword : String = confirmPasswordTextField.text!
        let isValid = Utils.isValidEmail(testStr: email)
        if (name.count > 0){
            if (lastName.count > 0){
                if isValid {
                    if (password.count > 4){
                        if (password == confirmPassword){
                            self.showActivityIndicator()
                            let controller = RegisterController.controller
                            controller.register(email: email, password: password, firstName: name, lastName: lastName, success: { (user) in
                                //Analytics
                                let date = Date()
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd-MM-yyyy HH:mm"
                                let actualDate = formatter.string(from: date)
                                let params = ["date":actualDate,"label":"register","so":"ios"] as [String:Any]
                                Analytics.logEvent("register", parameters: params)
                                
                                self.hideActivityIndicator()
                                self.presentMainViewController()
                            }, failure: { error in
                                self.requestDidFinishWithError(error)
                            })
                        }
                        else{
                            self.showErrorMessage(withTitle: "Campo de contraseña no concuerda")
                        }
                    }
                    else{
                        self.showErrorMessage(withTitle: "Contraseña debe ser mayor a 4 dígitos")
                    }
                }
                else{
                    self.showErrorMessage(withTitle: "Correo debe tener un formato válido")
                }
            }
            else{
                self.showErrorMessage(withTitle: "Campo apellido no puede ser vacío")
            }
        }
        else{
            self.showErrorMessage(withTitle: "Campo nombre no puede ser vacío")
        }
    }
    
    private func showSecurityEntry(textField:UITextField){
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        textField.becomeFirstResponder()
    }
    
}
