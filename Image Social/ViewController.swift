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
    
    //MARK: IBOutlet
    @IBOutlet weak var emailAddressTextField: CustomTextFields!
    @IBOutlet weak var passwordTextField: CustomTextFields!
    
    let firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
    
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
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
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
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
    }
    
    func checkIfFirstLaunch(){
        if UserDefaults.standard.object(forKey: "firstLaunch") == nil {
            let profileVC = ProfileVC()
            self.present(profileVC, animated: true, completion: nil)
        }
            performSegue(withIdentifier: "signInToFeedSegue", sender: self)
    }
    
    // MARK: IBActions
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        validateLogin()
        
        if let email = emailAddressTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            self.validateLogin()
                        } else {
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        _ = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        checkIfFirstLaunch()
    }
}

