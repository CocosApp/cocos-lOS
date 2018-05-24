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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        let introNavController = UIStoryboard(name: "Intro", bundle: Bundle.main).instantiateInitialViewController() as! UINavigationController
        UIView.transition(from: (window?.rootViewController?.view!)!, to: introNavController.view!, duration: 0.5, options: .transitionFlipFromRight, completion:{ finish in
            if finish == true {
                window?.rootViewController = introNavController
                UserEntity.unarchiveUser()
            }
        })
    }
    @IBAction func uploadProfileDidSelect(_ sender: UIButton) {
        if email != "invitado@gmail.com"{
            
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
