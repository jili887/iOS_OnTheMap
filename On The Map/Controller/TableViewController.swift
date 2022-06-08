//
//  TableViewController.swift
//  On The Map
//
//  Created by Jia Li on 6/6/22.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    var locations = [PinnedLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLocationsData()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: Load pined locations for Table view
    func loadLocationsData() {
        APIClient.getPinnedLocations(completion: { (pinnedLocations, error) in
            if (error != nil) {
                self.showDownloadError(message: error?.localizedDescription ?? "")
            } else {
                LocationModel.locationResults = pinnedLocations
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
    
    @IBAction func refreshData(_ sender: Any) {
        self.loadLocationsData()
        self.locations = LocationModel.locationResults
        self.tableView.reloadData()
    }
    
    // MARK: Handle download error
    func showDownloadError(message: String) {
        let alertVC = UIAlertController(title: "Download Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
