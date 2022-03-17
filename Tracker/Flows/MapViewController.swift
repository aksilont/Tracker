//
//  MapViewController.swift
//  Tracker
//
//  Created by Aksilont on 13.03.2022.
//

import UIKit
import GoogleMaps
import Combine

class MapViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - Properties
    
    private let coordinateMoscow = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private var currentLocation = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    var mapService = GoogleMapService()
    
    var marker: GMSMarker?
    var manualMarker: GMSMarker?
    var locationManager: CLLocationManager?
    var geocoder = CLGeocoder()
    var subscription: AnyCancellable?
    
    // MARK: - Lify cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureLocationManager()
        subscription = mapService.publisher.sink { [unowned self] in addressLabel.text = $0 }
    }
    
    // MARK: - Logic
    
    func setCamera(to location: CLLocationCoordinate2D) {
        mapView.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: 17))
    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinateMoscow, zoom: 17)
        mapView.camera = camera
        mapView.delegate = mapService
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.requestAlwaysAuthorization()
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

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location.coordinate
        mapService.addMarker(to: currentLocation, on: mapView)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
