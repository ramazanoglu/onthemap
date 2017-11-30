//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 22.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (StudentInformations.sharedInstance.data?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StudentsTableViewCell = self.studentsTableView.dequeueReusableCell(withIdentifier: "StudentsTableViewCell") as! StudentsTableViewCell!
        
        // set the text from the data model
        
        let firstName = StudentInformations.sharedInstance.data![indexPath.row].firstName ?? ""
        let lastName = StudentInformations.sharedInstance.data![indexPath.row].lastName ?? ""
        
            cell.nameLabel.text = firstName + " " + lastName
        cell.linkLabel.text = StudentInformations.sharedInstance.data![indexPath.row].mediaUrl ?? ""
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath)
        currentCell?.isSelected = false
        
        print(StudentInformations.sharedInstance.data![indexPath.row])
        
        if let url = URL(string: StudentInformations.sharedInstance.data![indexPath.row].mediaUrl!) {
            UIApplication.shared.open(url, options: [:])
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(getDataUpdate), name: NSNotification.Name(rawValue: StudentInformations.sharedInstance.dataModelDidUpdateNotification), object: nil)
    }
    
    @objc private func getDataUpdate() {
       
            performUIUpdatesOnMain {
                self.studentsTableView.reloadData()
            }
            
        
    }
    
}
