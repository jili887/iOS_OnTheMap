//
//  TableViewController.swift
//  On The Map
//
//  Created by Jia Li on 6/6/22.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.reloadData()
    }
    
    // MARK: Table View cell
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformationModel.locationResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinnedLocationCell")!
        
        let data = StudentInformationModel.locationResults[indexPath.row]
        
        cell.textLabel?.text = data.firstName + data.lastName
        cell.detailTextLabel?.text = data.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: StudentInformationModel.locationResults[indexPath.row].mediaURL) {
            UIApplication.shared.open(url)
        } else {
            showError(title: "Oops", message: "Unable to open the URL")
        }
    }
    
    //  MARK: Button functions
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        APIClient.getPinnedLocations(completion: { (success, error) in
            if success {
                self.tableView.reloadData()
            } else {
                self.showError(title: "Oops", message: error?.localizedDescription ?? "Refresh failed")
            }
        })
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        APIClient.logout{
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Handle download error
    func showError(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
