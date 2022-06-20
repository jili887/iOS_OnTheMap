//
//  MapViewController.swift
//  On The Map
//
//  Created by Jia Li on 6/8/22.
//

import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var locations = [PinnedLocation]()
    var annotations = [MKPointAnnotation]()
    let reuseId = "pin"
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        self.loadLocationsData()
        self.mapView.addAnnotations(annotations)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: Load pined locations for Map view
    func loadLocationsData() {
        APIClient.getPinnedLocations(completion: { (data, error) in
            guard let data = data else {
                self.showDownloadError(message: error?.localizedDescription ?? "")
                return
            }
            DispatchQueue.main.async {
                LocationModel.locationResults = data
                self.locations = LocationModel.locationResults
                self.parsePinnedLocations()
            }
        })
    }
    
    // MARK: Parse PinnedLocation to MKPointAnnotation
    func parsePinnedLocations() {
        for location in locations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            annotations.append(annotation)
        }
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
            }
        }
    }
    
    // MARK: Button functions
    @IBAction func refreshMapData(_ sender: UIBarButtonItem) {
        self.loadLocationsData()
        self.mapView.addAnnotations(annotations)
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        APIClient.logout {
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
