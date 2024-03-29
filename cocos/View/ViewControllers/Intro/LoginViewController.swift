//
//  LoginViewController.swift
//  cocos
//
//  Created by MIGUEL on 21/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import IQKeyboardManagerSwift

class LoginViewController : BaseUIViewController , GIDSignInDelegate, GIDSignInUIDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginScrollView: UIScrollView!
    
    var editingKeyboard = false
    
    let loginManager : FBSDKLoginManager = FBSDKLoginManager()
    
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Aceptar"
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        self.emailTextField.setBottomBorder()
        self.passwordTextField.setBottomBorder()
    }
    
    //Método que se encarga de configurar la posición de la selección del texto al activar el KeyBoard
    func adjustInsetForKeyboardShow(_ show : Bool, notification : Notification){
        let userInfo = notification.userInfo ?? [:] //Le doy la info del user
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue //Le damos la forma al keyboard
        let adjustmentheight = (keyboardFrame.height+20)*(show ? 1 : -1) //Ajustamos la altura según se deba mostrar y ocultar el keyboard
        loginScrollView.contentInset.bottom += adjustmentheight //Ajustamos el scroll en base a la altura del keyboad
        loginScrollView.scrollIndicatorInsets.bottom += adjustmentheight //configuramos los límites del scroll basados en la altura del keyboard
        
    }
    
    //Configuración para llegar a darle los comandos para los selector en la notificación del KeyBoard
    @objc func keyboardWillShow(_ notification : Notification){
        //hideKeyboard(self)
        
        if !editingKeyboard { //No ha estado editando antes desde otro filtro
            adjustInsetForKeyboardShow(true, notification: notification)
            editingKeyboard = true
        }else{ //Ha estado editando antes desde otro filtro, solo ha saltado entre filtros, es la primera vez que inicia
            adjustInsetForKeyboardShow(false, notification: notification)
        }
        
        //adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification : Notification){
        editingKeyboard = false
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    //Este método se encarga de detener las notificaciones cuando la vida del objeto ha culminado
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
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
                    //Analytics
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm"
                    let actualDate = formatter.string(from: date)
                    let params = ["id_user":user.id,"name_user":user.fullName,"date":actualDate,"label":"login","so":"ios"] as [String:Any]
                    Analytics.logEvent("login", parameters: params)
                    
                    self.hideActivityIndicator()
                    self.presentMainViewController()
                }, failure: { error in
                    self.hideActivityIndicator()
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
        let controller = LoginController.controller
        let hasPermissions = FBSDKAccessToken.current() != nil
        if hasPermissions {
            let token : String = FBSDKAccessToken.current().tokenString!
            self.showActivityIndicator()
            controller.loginFacebook(token, success: {user in
                //Analytics
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy HH:mm"
                let actualDate = formatter.string(from: date)
                let params = ["id_user":user.id,"name_user":user.fullName,"date":actualDate,"label":"login_fb","so":"ios"] as [String:Any]
                Analytics.logEvent("login_fb", parameters: params)
                
                self.loginManager.logOut()
                self.hideActivityIndicator()
                self.presentMainViewController()
                }, failure: { error in
                    self.hideActivityIndicator()
                    self.loginManager.logOut()
                    self.requestDidFinishWithError(error)
            })
        }
        else{
            loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
                if error != nil {
                    self.showErrorMessage(withTitle: (error?.localizedDescription)!)
                }
                else if (result?.isCancelled)! {
                    self.loginManager.logOut()
                    self.showSuccessMessage(withTitle: "Se canceló la petición a Facebook")
                }
                else {
                    let token : String = FBSDKAccessToken.current().tokenString!
                    self.showActivityIndicator()
                    controller.loginFacebook(token, success: {user in
                        //Analytics
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy HH:mm"
                        let actualDate = formatter.string(from: date)
                        let params = ["id_user":user.id,"name_user":user.fullName,"date":actualDate,"label":"login_fb","so":"ios"] as [String:Any]
                        Analytics.logEvent("login_fb", parameters: params)
                        
                        self.loginManager.logOut()
                        self.hideActivityIndicator()
                        self.presentMainViewController()
                    }, failure: { error in
                        self.hideActivityIndicator()
                        self.loginManager.logOut()
                        self.requestDidFinishWithError(error)
                    })
                }
            }
        }
        
    }
    
    @IBAction func gmailButtonDidSelect(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func guessButtonDidSelect(_ sender: UIButton) {
        let controller = LoginController.controller
        self.showActivityIndicator()
        controller.login(email: "invitado@gmail.com", password: "12345", success: {user in
            //Analytics
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            let actualDate = formatter.string(from: date)
            let params = ["date":actualDate,"label":"login_guest","so":"ios"] as [String:Any]
            Analytics.logEvent("login_guest", parameters: params)
            
            self.hideActivityIndicator()
            self.presentMainViewController()
        }, failure: { error in
            self.requestDidFinishWithError(error)
        })
    }
    
    //pragma Mark - delegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let controller = LoginController.controller
            self.showActivityIndicator()
            controller.loginGmail(user.authentication.idToken, success: { (user) in
                //Analytics
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy HH:mm"
                let actualDate = formatter.string(from: date)
                let params = ["id_user":user.id,"name_user":user.fullName,"date":actualDate,"label":"login_gmail","so":"ios"] as [String:Any]
                Analytics.logEvent("login_gmail", parameters: params)
                
                self.hideActivityIndicator()
                self.presentMainViewController()
            }) { (error) in
                self.hideActivityIndicator()
                self.requestDidFinishWithError(error)
            }
        }
        else{
            GIDSignIn.sharedInstance().signOut()
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}
