//
//  GoogleMapService.swift
//  Tracker
//
//  Created by Aksilont on 17.03.2022.
//

import GoogleMaps
import Combine

class GoogleMapService: NSObject, MapServiceProtocol {
    private let geocoder = CLGeocoder()
    private var marker: GMSMarker?
    private var manualMarker: GMSMarker?
    
    private let coordinateMoscow = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private var currentLocation = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    var contentView: UIView
    var mapView = GMSMapView()
    var publisher = PassthroughSubject<String, Never>()
    
    required init(contentView: UIView) {
        self.contentView = contentView
    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinateMoscow, zoom: 17)
        mapView.camera = camera
        mapView.delegate = self
        mapView.frame = contentView.frame
        contentView.addSubview(mapView)
    }
    
    func addMarker(to location: CLLocationCoordinate2D) {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        view.text = "🙂"
        
        if let marker = marker {
            marker.position = location
        } else {
            let marker = GMSMarker(position: location)
            marker.map = mapView
            marker.iconView = view
            self.marker = marker
        }
    }
    
    func addMarkerkToCurrentLocatin() {
        addMarker(to: currentLocation)
    }
    
    func setCamera(to location: CLLocationCoordinate2D) {
        mapView.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: 17))
    }
    
    func setCameraToCurrentLocation() {
        mapView.animate(to: GMSCameraPosition.camera(withTarget: currentLocation, zoom: 17))
    }
    
    func setCurrentLocation(_ location: CLLocationCoordinate2D) {
        currentLocation = location
    }
    
    func zoomIn() {
        
    }
    
    func zoomOut() {
        
    }
    
    func startRecordRoute() {
        
    }
    
    func stopRecordRoute() {
        
    }
}

extension GoogleMapService: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let manualMarker = manualMarker {
            manualMarker.position = coordinate
        } else {
            let manualMarker = GMSMarker(position: coordinate)
            manualMarker.map = mapView
            self.manualMarker = manualMarker
        }
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [unowned self] places, error in
            guard let address = places?.first else { return }
            
            let country = address.country ?? ""
            let city = address.locality ?? ""
            let street = address.thoroughfare ?? ""
            let houseNumber = address.subThoroughfare ?? ""
                           
            let addressString = "\(country), \(city), \(street), \(houseNumber)"
            publisher.send(addressString)
        }
    }
}
