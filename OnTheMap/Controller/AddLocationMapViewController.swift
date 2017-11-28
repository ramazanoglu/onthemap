//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 27.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation!
    var websiteUrl: String!
    var address: String!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(location)")
        print("\(websiteUrl)")
        
        mapView.delegate = self
        
        errorLabel.text = ""
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        annotation.title = websiteUrl!
        
        self.mapView.addAnnotation(annotation)
        
        centerMapOnLocation(location: location)
        
        mapView.selectAnnotation(annotation, animated: true)
        
        ParseClient.sharedInstance().getStudentLocation(uniqueKey: UdacityClient.sharedInstance().uniqueKey, completionHandler: ({data, error in
            
            guard error == nil else {
                return
            }
            
            
            guard let data = data else {
                return
            }
            
            
            ParseClient.sharedInstance().loggedInStudentInformation = data
            
            
            
        }))
        
        // Do any additional setup after loading the view.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  1000 , 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "identifier") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "identifier")
            annotationView?.canShowCallout = true
            
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
    @IBAction func finishClicked(_ sender: Any) {
        
        errorLabel.text = ""
        
        ParseClient.sharedInstance().createStudentLocation(mapString: address, mediaURL: websiteUrl, latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), completionHandler: ({data, error in
            
            performUIUpdatesOnMain {
                if error != nil {
                    
                    self.errorLabel.text = error
                    
                } else {
                    
                    self.performSegue(withIdentifier: "postSuccessSegue", sender: self)
                    
                }
            }
        }))
        
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
