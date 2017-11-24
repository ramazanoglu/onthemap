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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
