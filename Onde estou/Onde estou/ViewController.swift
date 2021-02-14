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
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    private var locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
    }
    
    private func initLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
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
            showAlertRequestPermissionLocation()
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
        if  let location = locations.last{
            applyLocationMap(location: location)
            showLocationDetail(location)
        }
    }
    
    private func showLocationDetail(_ location: CLLocation) {
        longitudeLabel.text = String(location.coordinate.latitude)
        latitudeLabel.text = String(location.coordinate.longitude)
        velocityLabel.text = String(location.speed)
        
        showAddress(location)
    }
    
    private func showAddress(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                
                if let placemarksRecived = placemarks,
                   let placemarkFirst = placemarksRecived.first {
                    
                    let thoroughfare = placemarkFirst.thoroughfare ?? ""
                    let subThoroughfare = placemarkFirst.subThoroughfare ?? ""
                    let locality = placemarkFirst.locality ?? ""
                    let subLocality = placemarkFirst.subLocality ?? ""
                    let postalCode = placemarkFirst.postalCode ?? ""
                    let country = placemarkFirst.country ?? ""
                    let administrativeArea = placemarkFirst.administrativeArea ?? ""
                    let subAdministrativeArea = placemarkFirst.subAdministrativeArea ?? ""
                    
                    let addressSingleText = "\(thoroughfare) - \(subThoroughfare) / \(locality) / \(country)"
                    self.addressLabel.text = addressSingleText
                    
                    let addressText = "\n thoroughfare: \(thoroughfare)" +
                        "\n subThoroughfare: \(subThoroughfare)" +
                        "\n locality: \(locality)" +
                        "\n subLocality: \(subLocality)" +
                        "\n postalCode: \(postalCode)" +
                        "\n country: \(country)" +
                        "\n administrativeArea: \(administrativeArea)" +
                        "\n subAdministrativeArea: \(subAdministrativeArea)"
                    
                    print(addressText)
                }
                
                
            }else{
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    private func applyLocationMap(location: CLLocation) {
        let latitude: CLLocationDegrees = location.coordinate.latitude
        let longitude: CLLocationDegrees = location.coordinate.longitude
        let deltaLatitude: CLLocationDegrees = 0.01
        let deltaLongitude: CLLocationDegrees = 0.01
        
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let areaVisualization = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        
        let region =  MKCoordinateRegion(center: location, span: areaVisualization)
        mapView.setRegion(region, animated: true)
    }
    
    private func showAlertRequestPermissionLocation() {
        let alertController = UIAlertController(title: "Permissão de localização",
                                                message: "Necessário permissão para à sua localização!",
                                                preferredStyle: .actionSheet)
        addAlertActions(alertController)
        present(alertController, animated: true, completion: nil)
    }
    
    private func addAlertActions(_ alertController: UIAlertController) {
        let configurationAction = UIAlertAction(title: "Abrir configurações",
                                                style: .default) { (action) in
            
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)"),
               UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alertController.addAction(configurationAction)
        alertController.addAction(cancelAction)
    }
    
    
    private func addPoint(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = "Teste"
        annotation.subtitle = "Teste description"
        mapView.addAnnotation(annotation)
    }
}
