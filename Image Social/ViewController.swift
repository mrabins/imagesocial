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
import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    @IBOutlet weak var emailAddressTextField: LogInFields!
    @IBOutlet weak var passwordTextField: LogInFields!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "signInToFeedSegue", sender: self)
        }
    }
    
    func firebaseAuthenticate(_ credential: AuthCredential) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.signIn(with: credential) { (user, error) in
            if error != nil {
                print("Unable to euthenticate - \(String(describing: error))")
            } else {
                print("Successfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        }
    }
    
    func validateEmail(enteredEmailAddress: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmailAddress)
    }
    
    func validateLogin() {
        if validateEmail(enteredEmailAddress: emailAddressTextField.text!) == false {
            let noEmailAlert = UIAlertController(title: "No Email", message: "Please Reenter A Valid Email And Try Again", preferredStyle: .alert)
            noEmailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            }))
            self.present(noEmailAlert, animated: true, completion: nil)
        }
        if (passwordTextField.text?.characters.count)! <= 6 {
            let passwordAlert = UIAlertController(title: "Password Error", message: "Your Password Does Not Meet Our Standards. Please Ensure You Have At Least 6 Characters And Try again", preferredStyle: .alert)
            passwordAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            }))
            self.present(passwordAlert, animated: true, completion: nil)
        }
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
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        
        validateLogin()
        
        if let email = emailAddressTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("Email User authtenticated with Firebase")
                    if let user = user {
                        self.completeSignIn(id: (user.uid))
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Failed to create a user - Unable to authenticate with Firebase using email")
                        } else {
                            print("Successfully authenticated with Firebase")
                            if let user = user {
                                self.completeSignIn(id: (user.uid))
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychainResult) ID is: \(id) key is: \(KEY_UID)")
        performSegue(withIdentifier: "signInToFeedSegue", sender: self)
        
    }
}

