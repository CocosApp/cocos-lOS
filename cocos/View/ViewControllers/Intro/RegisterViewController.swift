//
//  RegisterViewController.swift
//  cocos
//
//  Created by MIGUEL on 21/02/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

class RegisterViewController : BaseUIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerScrollView: UIScrollView!
    
    var editingKeyboard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Aceptar"
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    //Método que se encarga de configurar la posición de la selección del texto al activar el KeyBoard
    func adjustInsetForKeyboardShow(_ show : Bool, notification : Notification){
        let userInfo = notification.userInfo ?? [:] //Le doy la info del user
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue //Le damos la forma al keyboard
        let adjustmentheight = (keyboardFrame.height+20)*(show ? 1 : -1) //Ajustamos la altura según se deba mostrar y ocultar el keyboard
        registerScrollView.contentInset.bottom += adjustmentheight //Ajustamos el scroll en base a la altura del keyboad
        registerScrollView.scrollIndicatorInsets.bottom += adjustmentheight //configuramos los límites del scroll basados en la altura del keyboard
        
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
