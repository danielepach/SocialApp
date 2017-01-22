//
//  SignInVC.swift
//  SocialApp
//
//  Created by Daniele Pauciulo on 21/01/2017.
//  Copyright © 2017 PachApps. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var pwdField: FancyField!
    @IBOutlet weak var emailField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("DANY: Unable to authenticate with Facebook - \(error)")
            }  else if result?.isCancelled == true {
                print("DANY: User cancelled Facebook authentication")
            } else {
                print ("DANY: Successfully authenticated with facebook")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
                
            }
        }
        
    }
    
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("DANY: Unable to authenticate with firebase - \(error)")
            } else {
                print("DANY: Successfuly authenticated with Firebase")
                
            }
        })
    }
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("DANY: Email User authenticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("DANY: Unable to authenticate with Firebase using email - \(error)")
                        } else {
                            print("DANY: Successfully authenticated with Firebase using email")
                        }
                    })
                }
            })
        }
    }

}

