//
//  MapViewController.swift
//  Tracker
//
//  Created by Aksilont on 13.03.2022.
//

import UIKit
import CoreLocation
import Combine

class MapViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - Properties
    
    var mapService: MapServiceDelegate!
    var locationManager: CLLocationManager!
    
    var subscription: AnyCancellable?
    
    // MARK: - Lify cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapService()
        configureLocationManager()
    }
    
    // MARK: - Services
    
    func configureGoogleMapService() {
        mapService = GoogleMapService(mapView: mapView)
        mapService.configureMap()
    }
    
    func configureMapService() {
        configureGoogleMapService()
        subscription = mapService.publisher.sink { [unowned self] in addressLabel.text = $0 }
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.requestAlwaysAuthorization()
    }
    
    // MARK: - IBActions
    
    @IBAction func currentLocationTapped(_ sender: UIBarButtonItem) {
        mapService.setCameraToCurrentLocation()
    }
    
    // MARK: - Deinit
    
    deinit {
        locationManager?.stopUpdatingLocation()
        subscription = nil
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        mapService.setCurrentLocation(location.coordinate)
        mapService.addMarkerkToCurrentLocatin()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
