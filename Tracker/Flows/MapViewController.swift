//
//  MapViewController.swift
//  Tracker
//
//  Created by Aksilont on 13.03.2022.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Properties
    
    private let coordinateMoscow = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private var currentLocation = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    var marker: GMSMarker?
    var manualMarker: GMSMarker?
    var locationManager: CLLocationManager?
    
    // MARK: - Lify cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureLocationManager()
    }
    
    // MARK: - Logic
    
    func setCamera(to location: CLLocationCoordinate2D) {
        mapView.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: 17))
    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinateMoscow, zoom: 17)
        mapView.camera = camera
        mapView.delegate = self
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.requestAlwaysAuthorization()
    }
    
    func addMarker() {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        view.text = "🙂"
        
        let marker = GMSMarker(position: currentLocation)
        marker.map = mapView
        marker.iconView = view
        self.marker = marker
    }
    
    // MARK: - IBActions
    
    @IBAction func currentLocationTapped(_ sender: UIBarButtonItem) {
        setCamera(to: currentLocation)
    }
    
    // MARK: - Deinit
    
    deinit {
        locationManager?.stopUpdatingLocation()
    }
    
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let manualMarker = manualMarker {
            manualMarker.position = coordinate
        } else {
            let manualMarker = GMSMarker(position: coordinate)
            manualMarker.map = mapView
            self.manualMarker = manualMarker
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location.coordinate
        if let marker = marker {
            marker.position = currentLocation
        } else {
            addMarker()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
