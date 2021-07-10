//
//  MapViewController.swift
//  week-3
//
//  Created by Macbook on 10.07.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    let myLocation = CLLocation(latitude: 41.03315, longitude: 37.49341)
    
    var lastLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationServices()
    
    }
    
    func pinMyLocation() {
        let center = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude,longitude: myLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center,latitudinalMeters: 100,longitudinalMeters: 100)
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
    }
    
    func getMyLocationAddress() {
        geoCoder.reverseGeocodeLocation(myLocation) { (placemarks, error) in

            if let error = error {
                print(error)
                return
            }

            guard let placemark = placemarks?.first else { return }
            let name = placemark.name ?? ""
            let country = placemark.country ?? "Country"
            let city = placemark.administrativeArea ?? "City"
            let state = placemark.subAdministrativeArea ?? "State"

            self.addressLabel.text = "\(name) \(state), \(city), \(country)"
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //TODO: Kullanıcıya ayarlardan konum servisini açması istenebilir
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            pinMyLocation()
            getMyLocationAddress()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            break
        case .restricted:
            break
        }
    }

}


extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

