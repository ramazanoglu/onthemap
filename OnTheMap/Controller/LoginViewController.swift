//
//  ViewController.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 21.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        UdacityClient.sharedInstance().postSession(username: emailTextField!.text!, password: passwordTextField!.text!, completionHandler: {(result, error) in
             performUIUpdatesOnMain {
                if error == nil {
                    print(result)
                
                    self.performSegue(withIdentifier: "openTabBarSegue", sender: nil)

                
                } else {
              
                    self.displayError(error)
                }
            }
        })
        
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            errorTextView.text = errorString
        }
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        print("signup clicked")
    }
}

