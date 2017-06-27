//
//  ViewController.swift
//  Image Social
//
//  Created by Mark Rabins on 6/26/17.
//  Copyright © 2017 self.edu. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to Authenticate with FB")
            } else if result?.isCancelled == true {
                print("User cancelled FB Authentication")
            } else {
                print("Successfully Authenticated with FB")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
        
    }
    
    func firebaseAuthenticate(_ credential: AuthCredential) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.signIn(with: credential) { (user, error) in
            if error != nil {
                print("Unable to euthenticate - \(String(describing: error))")
            } else {
                print("Successfully authenticated with Firebase")
            }
        }
        
    }
   
}

