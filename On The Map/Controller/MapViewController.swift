//
//  MapViewController.swift
//  On The Map
//
//  Created by Jia Li on 6/8/22.
//

import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var annotations = [MKPointAnnotation]()
    let reuseId = "pin"
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        clearAnnotations()
        getStudentLocations()
    }
    
    // MARK: Get Pinned locations for MapView
    func getStudentLocations() {
        APIClient.getPinnedLocations(completion: { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.parseLocationsData()
                }
            } else {
                self.showError(title: "Oops", message: error?.localizedDescription ?? "Download failed")
            }
        })
    }
    
    // MARK: Parse and Load Pinned locations for MapView
    func parseLocationsData() {
        for location in StudentInformationModel.locationResults {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: Clear old Pinned locations
    func clearAnnotations() {
        self.annotations.removeAll()
        self.mapView.removeAnnotations(mapView.annotations)
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
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            } else {
                showError(title: "Oops", message: "Unable to open the URL")
            }
        }
    }
    
    // MARK: Button functions
    @IBAction func refreshMapData(_ sender: UIBarButtonItem) {
        APIClient.getPinnedLocations(completion: { (success, error) in
            if success {
                self.clearAnnotations()
                self.getStudentLocations()
            } else {
                self.showError(title: "Oops", message: error?.localizedDescription ?? "Refresh failed")
            }
        })
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        APIClient.logout {
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
