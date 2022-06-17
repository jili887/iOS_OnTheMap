//
//  ConfirmViewController.swift
//  On The Map
//
//  Created by Jia Li on 6/13/22.
//

import Foundation
import UIKit
import MapKit

class ConfirmViewController: UIViewController, MKMapViewDelegate {
    
    var mapLocation = MKPointAnnotation()
    var location = CLLocationCoordinate2D()
    var locationString = ""
    var url = ""
    
    @IBOutlet weak var confirmMapView: MKMapView!
    
    
    @IBAction func finish(_ sender: Any) {
        APIClient.getUserData(completion: {(userDataReponse, error) in
            guard let userDataReponse = userDataReponse else {
                return
            }

            let studentLocationRequest = PostStudentLocationRequest(uniqueKey: userDataReponse.accountKey, firstName: userDataReponse.firstName, lastName: userDataReponse.lastName, mapString: self.locationString, mediaURL: self.url, latitude: Double(self.location.latitude), longitude: Double(self.location.longitude))
            self.postLocation(postRequest: studentLocationRequest)
        })
    }
    
    func postLocation(postRequest: PostStudentLocationRequest) {
        APIClient.postStudentLocation(postRequest: postRequest, completion: {(postResponse, error) in
            if (error != nil) {
                self.showError(message: error?.localizedDescription ?? "")
            } else {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Add new location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
