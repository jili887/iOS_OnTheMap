//
//  AddPinViewController.swift
//  On The Map
//
//  Created by Jia Li on 6/12/22.
//

import Foundation
import UIKit
import CoreLocation

class AddPinViewController: UIViewController {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var locationCoordinate =  CLLocationCoordinate2D()
    
    // MARK: Find location button
    @IBAction func findLocation(_ sender: Any) {
        if (locationField.text == nil || locationField.text == "") {
            showError(message: "Please enter a new location")
            return
        }
        
        if (urlField.text == nil || urlField.text == "") {
            showError(message: "Please enter an URL")
            return
        }
        setLoadingIndicator(true)
        let geoCoder = CLGeocoder()
        let location = locationField.text!
        geoCoder.geocodeAddressString(location) { (data, error) in
            self.setLoadingIndicator(false)
            guard let data = data else {
                self.showError(message: "Can not find this location: \(location)")
                return
            }
            self.locationCoordinate = data.first!.location!.coordinate
            self.performSegue(withIdentifier: "confirmLocation", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmLocation" {
            let confirmVC = segue.destination as! ConfirmViewController
            confirmVC.location = self.locationCoordinate
            confirmVC.locationString = self.locationField.text ?? ""
            confirmVC.url = self.urlField.text ?? ""
        }
    }
    
    // MARK: Cancel button
    @IBAction func cancelAddPin(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    
    func setLoadingIndicator(_ loading: Bool) {
        findLocationButton.isEnabled = !loading
        if loading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Erorr", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
