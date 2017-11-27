//
//  HeaderView.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 23.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    let notificationId = "headerViewAddPinNotification"
    
    @IBOutlet var contentView: UIView!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initXib()
    }
    
    
    func initXib() {
        
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    @IBAction func logout(_ sender: Any) {
        print("logout")
    }
    
    @IBAction func refresh(_ sender: Any) {
        print("refresh")
        
        StudentInformations.sharedInstance.requestData()
    }
    
    
    @IBAction func addPin(_ sender: Any) {
        print("addPin")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationId), object: nil)
        
    }
}
