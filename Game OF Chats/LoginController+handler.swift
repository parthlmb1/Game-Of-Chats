//
//  LoginController+handler.swift
//  Game OF Chats
//
//  Created by Parth Lamba on 28/02/18.
//  Copyright © 2018 Parth Lamba. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
    func handleSelectProfileImageview(){
        let imagePickerVC = UIImagePickerController()
        
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
    
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var  selectedImageFromImagePickerVC: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromImagePickerVC = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromImagePickerVC = originalImage
        }
        
        if let selectedImage = selectedImageFromImagePickerVC {
            profileImageView.image = selectedImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //print(123)
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
            }
            
            //sucessfull
            
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            
            let store = Storage.storage().reference(forURL: "gs://gameofchats-c579f.appspot.com/files")
            let storageRef = store.child ("profileImages").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
            
            //if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImage = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImage": profileImage]
                    
                        self.registerUserInDatabaseWithUID(uid: uid, values: values)
                    }
                })
            }
        }
    }
    
    private func registerUserInDatabaseWithUID(uid: String, values:[String: Any] ) {
        var ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://gameofchats-c579f.firebaseio.com/")
        
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            
            //self.messagesController?.fetchUserAndSetupNavBarTitle()
            self.messagesController?.navigationItem.title = values["name"] as! String

            self.dismiss(animated: true, completion: nil)
            
            //sucessfull
            print("User sucessfully saved in Database")
        })
    }
}
