//
//  LoginViewController.swift
//  Grocery-List
//
//  Created by 라완 💕 on 15/06/1444 AH.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToItems = "LoginToItems"
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentSignIn()
    }
    
    // // get the currently signed-in user
    func currentSignIn() {
        Auth.auth().addStateDidChangeListener
        { auth, user in
            if user != nil
            {
                self.performSegue(withIdentifier: self.loginToItems, sender: nil)
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
            }
        }
    }
    
    // (Authenticating Users) Logging Users In
    @IBAction func loginClickIt(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            email.count > 0,
            password.count > 0
                
        else {return}
        
        Auth.auth().signIn(withEmail: email, password: password)
        { user, error in
            if let error = error, user == nil
            {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // (Authenticating Users) Registering Users
    @IBAction func signUpClickIt(_ sender: UIButton) {
        guard
            let emailField = self.emailTextField.text,
            let passwordField = passwordTextField.text,
            emailField.count > 0,
            passwordField.count > 0
            
            else {return}
        Auth.auth().createUser(withEmail: emailField, password: passwordField)
        { user, error in
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == emailTextField {
          passwordTextField.becomeFirstResponder()
      }
      if textField == passwordTextField {
        textField.resignFirstResponder()
      }
      return true
    }
  }


