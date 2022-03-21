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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - Properties
    var mapServiceType: MapServiceType!
    private var mapService: MapServiceProtocol!
    private var locationManager: CLLocationManager!
    
    private var subscription: AnyCancellable?
    
    // MARK: - Lify cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapService()
        configureLocationManager()
    }
    
    // MARK: - Services
    
    func configureMapService() {
        switch mapServiceType {
        case .google:
            mapService = GoogleMapService(contentView: contentView)
        case .apple:
            mapService = AppleMapService(contentView: contentView)
        case .none:
            mapService = GoogleMapService(contentView: contentView)
        }
        mapService.contentView = contentView
        mapService.configureMap()
        
        subscription = mapService.publisher.sink { [unowned self] in addressLabel.text = $0 }
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
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
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        mapService.setCurrentLocation(location.coordinate)
        mapService.addMarkerkToCurrentLocatin()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
