//
//  ViewController.swift
//  Onde estou
//
//  Created by Gilberto da Luz on 13/02/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        //initMap()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        let status =  manager.authorizationStatus
        switch status {
        case .notDetermined:
            print("Status: notDetermined")
        case .restricted:
            print("Status: restricted")
        case .denied:
            print("Status: denied")
            let alertController = UIAlertController(title: "Permissão de localização",
                                                    message: "Necessário permissão para à sua localização!",
                                                    preferredStyle: .actionSheet)
            let configurationAction = UIAlertAction(title: "Abrir configurações",
                                                    style: .default) { (action) in
                
                if let bundleId = Bundle.main.bundleIdentifier,
                   let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)"), UIApplication.shared.canOpenURL(url)
                {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar",
                                             style: .default, handler: nil)
            
            alertController.addAction(configurationAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        case .authorizedAlways:
            print("Status: authorizedAlways")
        case .authorizedWhenInUse:
            print("Status: authorizedWhenInUse")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("Status: nil")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        if  let location = locations.last{
        //            let latitude: CLLocationDegrees = location.coordinate.latitude
        //            let longitude: CLLocationDegrees = location.coordinate.longitude
        //
        //            applyLocation(latitude: latitude, longitude: longitude)
        //        }
    }
    
    private func initMap() {
        let latitude: CLLocationDegrees = -19.90015864666512
        let longitude: CLLocationDegrees = -44.08706408887549
        
        applyLocation(latitude: latitude, longitude: longitude)
        addPointMyHouse(latitude, longitude)
    }
    
    private func addPointMyHouse(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = "Casa"
        annotation.subtitle = "Casa dos meus pais"
        mapView.addAnnotation(annotation)
    }
    
    private func applyLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let deltaLatitude: CLLocationDegrees = 0.01
        let deltaLongitude: CLLocationDegrees = 0.01
        
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let areaVisualization = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        
        let region =  MKCoordinateRegion(center: location, span: areaVisualization)
        mapView.setRegion(region, animated: true)
    }
    
    
    
}
