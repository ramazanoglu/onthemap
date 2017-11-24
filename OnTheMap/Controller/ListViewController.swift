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

    
    var studentsInformations = [StudentInformation]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentsInformations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StudentsTableViewCell = self.studentsTableView.dequeueReusableCell(withIdentifier: "StudentsTableViewCell") as! StudentsTableViewCell!
        
        // set the text from the data model
        cell.nameLabel.text = self.studentsInformations[indexPath.row].firstName! + " " +  self.studentsInformations[indexPath.row].lastName!
        cell.linkLabel.text = self.studentsInformations[indexPath.row].mediaUrl
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath)
        currentCell?.isSelected = false
        
        print(studentsInformations[indexPath.row])
        
        if let url = URL(string: studentsInformations[indexPath.row].mediaUrl!) {
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
        if let data = StudentInformations.sharedInstance.data {
            self.studentsInformations = data
            
            performUIUpdatesOnMain {
                self.studentsTableView.reloadData()
                
            }
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
