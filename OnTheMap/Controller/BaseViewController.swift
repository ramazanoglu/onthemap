//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 23.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openAddLocation), name: NSNotification.Name(rawValue: "headerViewAddPinNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name(rawValue: "headerViewLogoutNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "headerViewRefreshNotification"), object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func openAddLocation() {
        performUIUpdatesOnMain {
            self.performSegue(withIdentifier: "addLocationSegue", sender: self)
        }
    }
    
    @objc private func refresh() {
        
        StudentInformations.sharedInstance.requestData(completionHandler: { result, error in
            guard error == nil else {
                
                let alert = UIAlertController(title: "Error", message:error, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                }))
                
                
                
                self.present(alert, animated: true, completion: nil)
                return
            }
        })
        
    }
    
    @objc private func logout() {
        performUIUpdatesOnMain {
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
        }
    }
}
