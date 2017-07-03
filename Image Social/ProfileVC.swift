//
//  ProfileVC.swift
//  Image Social
//
//  Created by Mark Rabins on 7/3/17.
//  Copyright © 2017 self.edu. All rights reserved.
//

import UIKit


class ProfileVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var usernameTextField: CustomTextFields!
    @IBOutlet weak var profileImageView: CircleImageView!
    @IBOutlet weak var saveButton: CustomButton!
    
    //MARK: Global Variables
    var profileImagePicker: UIImagePickerController!
    var profileImageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImagePicker = UIImagePickerController()
        profileImagePicker.delegate = self
        profileImagePicker.allowsEditing = true
        
        self.usernameTextField.delegate = self
        
        usernameTextField.addTarget(self, action: #selector(profileComplete), for: .editingChanged)
    }
    
        func profileComplete(_ usernameTextField: UITextField, profileImageView: UIImageView) {
            if (usernameTextField.text?.characters.count)! >= 1 {
                profileImageSelected = false
            }
        }
    
    
    //MARK: IBAction
    @IBAction func saveButtonTapped(_ sender: UIButton) {

        
    }
    
    @IBAction func selectionProfileImageView(_ sender: UITapGestureRecognizer) {
        present(profileImagePicker, animated: true, completion: nil)
    }
}


//MARK: Extension
extension ProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        return true
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let profileImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.image = profileImage
            profileImageSelected = true
        }
        profileImagePicker.dismiss(animated: true, completion: nil)
    }
}

