//
//  TableViewController.swift
//  On The Map
//
//  Created by Jia Li on 6/6/22.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    var locations = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLocationsData()
        self.locations = StudentInformationModel.locationResults
        self.tableView.reloadData()
    }
    
    // MARK: Load pined locations for Table view
    func loadLocationsData() {
        APIClient.getPinnedLocations(completion: { (data, error) in
            guard let data = data else {
                self.showDownloadError(message: error?.localizedDescription ?? "")
                return
            }
            DispatchQueue.main.async {
                StudentInformationModel.locationResults = data
                self.locations = StudentInformationModel.locationResults
            }
        })
    }
    
    // MARK: Table View cell
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinnedLocationCell")!
        
        let data = self.locations[indexPath.row]
        
        cell.textLabel?.text = data.firstName + data.lastName
        cell.detailTextLabel?.text = data.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: self.locations[indexPath.row].mediaURL) {
            UIApplication.shared.open(url)
        }
    }
    
    //  MARK: Button functions
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        self.loadLocationsData()
        self.locations = StudentInformationModel.locationResults
        self.tableView.reloadData()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        APIClient.logout{
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Handle download error
    func showDownloadError(message: String) {
        let alertVC = UIAlertController(title: "Download Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
