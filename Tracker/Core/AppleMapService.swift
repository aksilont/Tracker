//
//  AppleMapService.swift
//  Tracker
//
//  Created by Aksilont on 20.03.2022.
//

import Foundation
import Combine
import CoreLocation
import MapKit

class AppleMapService: NSObject, MapServiceProtocol {
    private let geocoder = CLGeocoder()
    private var marker: MKPointAnnotation = MKPointAnnotation()
    private var manualMarker: MKPointAnnotation = MKPointAnnotation()
    
    private let coordinateMoscow = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private var currentLocation = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    var contentView: UIView
    var mapView = MKMapView()
    var publisher = PassthroughSubject<String, Never>()
    
    required init(contentView: UIView) {
        self.contentView = contentView
    }
    
    func configureMap() {
        let region = MKCoordinateRegion(center: coordinateMoscow, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.delegate = self
        mapView.frame = contentView.frame
        mapView.setRegion(region, animated: true)
        contentView.addSubview(mapView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTheMap))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapOnTheMap(_ sender: UIGestureRecognizer) {
        let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
        manualMarker.coordinate = coordinate
        mapView.removeAnnotation(manualMarker)
        mapView.addAnnotation(manualMarker)
    }
    
    func setCurrentLocation(_ location: CLLocationCoordinate2D) {
        currentLocation = location
    }
    
    func addMarker(to location: CLLocationCoordinate2D) {
        marker.coordinate = location
        mapView.removeAnnotation(marker)
        mapView.addAnnotation(marker)
    }
    
    func addMarkerkToCurrentLocatin() {
        addMarker(to: currentLocation)
    }
    
    func setCamera(to location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: 200,
                                        longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
    }
    
    func setCameraToCurrentLocation() {
        setCamera(to: currentLocation)
    }
}

extension AppleMapService: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let customAnnotationView = MKAnnotationView()
        let smileLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        smileLabel.text = "🙂"
        customAnnotationView.addSubview(smileLabel)
        return customAnnotationView
    }
}
