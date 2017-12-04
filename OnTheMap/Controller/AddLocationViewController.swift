//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 27.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var location: CLLocation!
    var websiteLink: String!
    var address: String!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationMapSegue" {
            if let toViewController = segue.destination as? AddLocationMapViewController {
                toViewController.location = self.location
                toViewController.websiteUrl = self.websiteLink
                toViewController.address = self.address
            }
        }
    }
    
    override func viewDidLoad() {
        updateActivityIndicatorView(isActive: false)
        
        locationTextField.delegate = self
        linkTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
    @IBAction func findLocationClicked(_ sender: Any) {
        
        updateActivityIndicatorView(isActive: true)
        
        
        errorLabel.text = ""
        
        guard locationTextField.text != "" else {
            
            errorLabel.text = "Location cannot be empty"
            updateActivityIndicatorView(isActive: false)

            
            return
        }
 
        guard linkTextField.text != "" else {
            
            errorLabel.text = "Website cannot be empty"
            updateActivityIndicatorView(isActive: false)

            
            return
        }
        
        let address = locationTextField.text
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                
                else {
                    self.errorLabel.text = "Address couldn't be converted"
                    self.updateActivityIndicatorView(isActive: false)

                    return
            }
            
            self.address = address
            self.location = location
            self.websiteLink = self.linkTextField.text!
            
            self.performSegue(withIdentifier: "addLocationMapSegue", sender: self)
            
            self.updateActivityIndicatorView(isActive: false)

        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateActivityIndicatorView(isActive:Bool) {
        
        performUIUpdatesOnMain {
            
        
        if isActive {
            self.activityIndicatorView.startAnimating()
            self.activityIndicatorView.alpha = 1
            
            self.locationTextField.isEnabled = false
            self.linkTextField.isEnabled = false
            self.findLocationButton.isEnabled = false


        } else {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.alpha = 0
            
            self.locationTextField.isEnabled = true
            self.linkTextField.isEnabled = true
            self.findLocationButton.isEnabled = true

        }
        
        }
    }
    
}
