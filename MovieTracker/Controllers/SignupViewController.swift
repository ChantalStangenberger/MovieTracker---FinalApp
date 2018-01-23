//
//  SignupViewController.swift
//  MovieTracker
//
//  Created by Chantal Stangenberger on 05-01-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Allows the user to create an account for MovieTracker.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailSignupField: UITextField!
    @IBOutlet weak var passwordSignupField: UITextField!

    // checks if emailfield and passwordfield are filled in: if there's no conflict with firebase, create user and log in
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
        if emailSignupField.text == "" || passwordSignupField.text == ""{
            UIView.animate(withDuration: 0.5, animations: {
                let rightTransform  = CGAffineTransform(translationX: 44, y: 9)
                self.emailSignupField.transform = rightTransform
                self.passwordSignupField.transform = rightTransform

            }) { (_) in

                UIView.animate(withDuration: 0.5, animations: {
                    self.emailSignupField.transform = CGAffineTransform.identity
                    self.passwordSignupField.transform = CGAffineTransform.identity
                })
            }
        } else {
            Auth.auth().createUser(withEmail: emailSignupField.text!, password: passwordSignupField.text!) { (user, error) in
                if error == nil {
                    self.storeUserData(userId: (user?.uid)!)
                    Auth.auth().signIn(withEmail: self.emailSignupField.text!, password: self.passwordSignupField.text!)
                    self.performSegue(withIdentifier: "FromRegisterLogin", sender: self)
                } else {
                    let alert = UIAlertController(title: "Whoops!", message: "user already exists / incorrect email / password does not meet requirements", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }

        }
    }
    
    // creates path in database with unique userid and email
    func storeUserData(userId: String) {
        Database.database().reference().child("users").child(userId).setValue([
            "email": emailSignupField.text,
            "uid": Auth.auth().currentUser?.uid])
    }

    // cancel button: go back to log in page
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
          self.performSegue(withIdentifier: "Cancel", sender: nil)
    }
}
 
