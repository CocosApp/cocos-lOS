//
//  ProfileViewController.swift
//  cocos
//
//  Created by MIGUEL on 22/04/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController : UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    var email : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
    }
    
    @IBAction func closeSessionDidSelect(_ sender: UIButton) {
        UserEntity.unarchiveUser()
        
        let introNavController = UIStoryboard(name: "Intro", bundle: Bundle.main).instantiateViewController(withIdentifier: "loginViewController")
        self.navigationController?.popToRootViewController(animated: false)
        self.navigationController?.pushViewController(introNavController, animated: true);
    }
    @IBAction func uploadProfileDidSelect(_ sender: UIButton) {
        if email != "invitado@gmail.com"{
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func setupData(){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        firstNameLabel.text = user.firstName
        lastNameLabel.text = user.lastName
        email = user.email
        emailLabel.text = email
        let photo = user.picture
        if photo != "" {
            profilePhoto.af_setImage(withURL: URL(string: photo)!)
        }
    }
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true) {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.profilePhoto.image = pickedImage
            }
        }
    }
}
