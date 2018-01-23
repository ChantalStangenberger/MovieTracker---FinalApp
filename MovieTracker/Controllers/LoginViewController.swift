//
//  LoginViewController.swift
//  MovieTracker
//
//  Created by Chantal Stangenberger on 03-01-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // if user already has an account (which is logged in), than go to the NowPlayingMovies page
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "Login", sender: nil)
            }
        }
    }

    // checks if emailfield and passwordfield are filled in: if user exists in firebase log in to MovieTracker
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        if emailField.text == "" || passwordField.text == ""{
            UIView.animate(withDuration: 0.5, animations: {
                let rightTransform  = CGAffineTransform(translationX: 44, y: 9)
                self.emailField.transform = rightTransform
                self.passwordField.transform = rightTransform
                
            }) { (_) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.emailField.transform = CGAffineTransform.identity
                    self.passwordField.transform = CGAffineTransform.identity
                })
            }
        } else {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Whoops!", message: "Incorrect email or password", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // sign up button: go to the sign up page
    @IBAction func signupButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "SignupController", sender: self)
    }
}

