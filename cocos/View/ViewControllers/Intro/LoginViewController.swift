//
//  LoginViewController.swift
//  cocos
//
//  Created by MIGUEL on 21/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController : BaseUIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let loginManager : FBSDKLoginManager = FBSDKLoginManager()
    
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func loginButtonDidSelect(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let isValid = Utils.isValidEmail(testStr: email)
        if (isValid){
            if (password.count>0){
                let controller = LoginController.controller
                self.showActivityIndicator()
                controller.login(email: email, password: password, success: {user in
                    self.hideActivityIndicator()
                    self.presentMainViewController()
                }, failure: { error in
                    self.requestDidFinishWithError(error)
                })
            }
            else{
                self.showErrorMessage(withTitle:"El campo contraseña no puede ser vacío")
            }
        }
        else{
            self.showErrorMessage(withTitle: "El correo no posee formato adecuado")
        }
    }
    @IBAction func FacebookButtonDidSelect(_ sender: UIButton) {
        let hasPermissions = FBSDKAccessToken.current() != nil
        if hasPermissions {
            
        }
        else{
            loginManager.logIn(withPublishPermissions: ["public_profile","email"], from: self) { (result, error) in
                if error != nil {
                    self.showErrorMessage(withTitle: (error?.localizedDescription)!)
                }
                else if (result?.isCancelled)! {
                    self.loginManager.logOut()
                    self.showSuccessMessage(withTitle: "Se canceló la petición a Facebook")
                }
                else {
                    
                }
            }
        }
        
    }
    
    @IBAction func gmailButtonDidSelect(_ sender: UIButton) {
    }
    
    @IBAction func guessButtonDidSelect(_ sender: UIButton) {
        let controller = LoginController.controller
        self.showActivityIndicator()
        controller.login(email: "invitado@gmail.com", password: "12345", success: {user in
            self.hideActivityIndicator()
            self.presentMainViewController()
        }, failure: { error in
            self.requestDidFinishWithError(error)
        })
    }
    
}
