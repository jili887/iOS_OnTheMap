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
    let reuseId = "pin"
    
    @IBOutlet weak var confirmMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmMapView.setCenter(location, animated: false)
        confirmMapView.addAnnotation(mapLocation)
    }
    
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
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let app = UIApplication.shared
        if let toOpen = view.annotation!.subtitle! {
            app.open(URL(string: toOpen)!)
        }
    }
}
