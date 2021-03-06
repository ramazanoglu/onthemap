//
//  ViewController.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 21.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorTextView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activityIndicatorView.alpha = 0
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        
        errorTextView!.text = ""
        
        
        guard emailTextField!.text != "" else {
            errorTextView.text! = "Email cannot be empty"
            return
        }
        
        guard passwordTextField!.text != "" else {
            errorTextView.text! = "Password cannot be empty"
            return
        }
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.alpha = 1

        
        UdacityClient.sharedInstance().postSession(username: emailTextField!.text!, password: passwordTextField!.text!, completionHandler: {(result, error) in
             performUIUpdatesOnMain {
                if error == nil {
                    self.performSegue(withIdentifier: "openTabBarSegue", sender: nil)
                 

                } else {
              
                    self.displayError(error)
                }
                
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.alpha = 0

            }
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { 
        textField.resignFirstResponder()
        return true
    }

    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            errorTextView.text = errorString
        }
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url, options: [:])
        }

    }
}

