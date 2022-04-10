//
//  LocationManager.swift
//  Tracker
//
//  Created by Aksilont on 27.03.2022.
//

import CoreLocation
import RxSwift

class LocationManager: NSObject {
    
    private var locationManager: CLLocationManager!
    
    private var locationSubject = PublishSubject<CLLocationCoordinate2D>()
    var locationSubjectObservable: Observable<CLLocationCoordinate2D> {
        return locationSubject.asObservable()
    }
    
    override init() {
        super.init()
        configureLocationManager()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
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
}

extension LocationManager: CLLocationManagerDelegate {
    
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
        locationSubject.onNext(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
