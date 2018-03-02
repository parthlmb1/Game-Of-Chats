//
//  LoginViewController.swift
//  Game OF Chats
//
//  Created by Parth Lamba on 09/12/17.
//  Copyright © 2017 Parth Lamba. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var messagesController: MessagesViewController?

    var inputsContainerViewHeightAnchor: NSLayoutConstraint? //reference to Inputs Container View
    var nameTextFieldHeightAnchor: NSLayoutConstraint? // reference to name Text Field
    var emailTextFieldHeightAnchor: NSLayoutConstraint? // reference to email Text Field
    var passwordTextFieldHeightAnchor: NSLayoutConstraint? //reference to password Text Field
    
    lazy var profileImageView : UIImageView = {
        let profileView  = UIImageView()
        profileView.image = UIImage(named:"profile")
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.contentMode = .scaleAspectFill
        
        profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageview)))
        profileView.isUserInteractionEnabled = true
        
        return profileView
    }()
    
    
    let loginRegisterSegementedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegementedController.titleForSegment(at: loginRegisterSegementedController.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegementedController.selectedSegmentIndex == 0 ? 100 : 150
        
        //Change height of Name Text Field
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegementedController.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //Change height of Email Text Field
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegementedController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //Change height of password Text Field
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegementedController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    
    }
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white //changes Color
        view.translatesAutoresizingMaskIntoConstraints = false //makes the view appear on the screen
        view.layer.cornerRadius = 5 //Sets Corner Radius
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let loginButton = UIButton(type: .system) //Creats an Object of type System Button
        loginButton.backgroundColor = UIColor(r: 80, g: 101, b: 161) //changes Color
        loginButton.setTitle("Register", for: .normal) //Sets Title
        loginButton.translatesAutoresizingMaskIntoConstraints = false //makes the button appear on the screen
        loginButton.layer.cornerRadius = 5 //Sets Corner Radius
        loginButton.layer.masksToBounds = true
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "helvetica", size: 20)
        //loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        loginButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return loginButton
    }()
    
    func handleLoginRegister(){
        if loginRegisterSegementedController.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email , password: password , completion: {(user, error) in
            if (error) != nil {
                
                let alert = UIAlertController(title: "OOPs!!", message: "Email or password are incorrect!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            } else {
                
                //Sucessful Login
                self.messagesController?.fetchUserAndSetupNavBarTitle()
                
                self.dismiss(animated: true, completion: nil)
                
            }
        })
    }
    
    
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameFieldSeperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        return seperatorView
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailFieldSeperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        return seperatorView
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Changes the UIView Color
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        //Adds the InputsContainerView as Sub view of the UIView
        //Calls the Fuction to position the view on UIView
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegementedController)
        
        setupInputsContainerConstraints()
        setupLoginButtonConstraints()
        setupProfileImageViewConstraints()
        setupLoginRegisterSegementedView()
    }
    
    func setupLoginRegisterSegementedView(){
        //Layout Constraints for inputsContainerView {x,y,height, width}
        loginRegisterSegementedController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegementedController.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegementedController.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegementedController.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    func setupInputsContainerConstraints(){
        //Layout Constraints for inputsContainerView {x,y,height, width}
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
    
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameFieldSeperatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailFieldSeperatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        setupNameTextFieldConstraints()
        setupNameFieldSeperatorViewConstraints()
        setupEmailTextFieldConstraints()
        setupEmailFieldSeperstorViewConstraints()
        setupPasswordTextFieldConstraints()
    }
    
    func setupNameTextFieldConstraints() {
        //Layout Constraints for nameTextField {x,y,height, width}
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -12).isActive = true
        
        //Height Anchor reference
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
    }
    
    func setupEmailTextFieldConstraints(){
        //Layout Constraints for nameTextField {x,y,height, width}
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameFieldSeperatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -12).isActive = true
        
        //Height Anchor reference
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
    }
    
    func setupPasswordTextFieldConstraints(){
        //Layout Constraints for nameTextField {x,y,height, width}
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailFieldSeperatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -12).isActive = true
        
        //Height Anchor referene
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupNameFieldSeperatorViewConstraints() {
        //Layout Constraints for Seperator View {x, h, height, width}
        nameFieldSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameFieldSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameFieldSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -20).isActive = true
        nameFieldSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupEmailFieldSeperstorViewConstraints() {
        emailFieldSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailFieldSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailFieldSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -20).isActive = true
        emailFieldSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupProfileImageViewConstraints() {
        //Layout Constraints for inputsContainerView {x,y,height, width}
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegementedController.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginButtonConstraints() {
         //Layout Constraints for LoginButton {x,y,height, width}
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    
    //extension for color value
    /*
        * Whenever we call the UIColor function now and give it some values it will automatically use the value by 255
        *r,g,b represents the red, green, blue values
     */
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
