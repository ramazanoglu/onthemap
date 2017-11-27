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
        
        StudentInformations.sharedInstance.requestData()

        NotificationCenter.default.addObserver(self, selector: #selector(openAddLocation), name: NSNotification.Name(rawValue: "headerViewAddPinNotification"), object: nil)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @objc private func openAddLocation() {
        
        performSegue(withIdentifier: "addLocationSegue", sender: self)
        
    }
}
