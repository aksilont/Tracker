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
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - IBActions
    
    @IBAction func currentLocationTapped(_ sender: UIButton) {
        mapService.setCameraToCurrentLocation()
    }
    
    @IBAction func zoomInTapped(_ sender: UIButton) {
        mapService.zoomIn()
    }
    
    @IBAction func zoomOutTapped(_ sender: UIButton) {
        mapService.zoomOut()
    }
    
    @IBAction func startStopRecordRoute(_ sender: UIButton) {
        mapService.startStopRecordRoute()
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
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // TODO: Сообщить пользователю, что нужно включить службу локации на телефоне
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
                // TODO: Сообщить пользователю, что у приложения нет доступа к службам локации
            break
        @unknown default:
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        mapService.setCurrentLocation(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
