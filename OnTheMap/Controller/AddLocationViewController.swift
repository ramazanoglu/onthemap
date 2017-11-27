//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 27.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!

    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func findLocationClicked(_ sender: Any) {
        
        errorLabel.text = ""
        
        guard locationTextField.text != "" else {
            
            errorLabel.text = "Location cannot be empty"
            
            return
        }
 
        guard linkTextField.text != "" else {
            
            errorLabel.text = "Website canoot be empty"
            
            return
            
        }
        
        let address = locationTextField.text
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                
                else {
                    // handle no location found
                    self.errorLabel.text = "Invalid address"
                    return
            }
            
            print("Location \(location)")

            self.performSegue(withIdentifier: "addLocationMapSegue", sender: self)
        
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
