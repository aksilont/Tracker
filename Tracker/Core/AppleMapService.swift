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
    private var radius = 500.0
    
    var contentView: UIView
    var mapView = MKMapView()
    var publisher = PassthroughSubject<String, Never>()
    private var radiusPublisher = PassthroughSubject<Double, Never>()
    private var subscription: Set<AnyCancellable> = []
    
    required init(contentView: UIView) {
        self.contentView = contentView
    }
    
    func configureMap() {
        let region = MKCoordinateRegion(center: coordinateMoscow, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.delegate = self
        mapView.frame = contentView.frame
        mapView.setRegion(region, animated: true)
        contentView.insertSubview(mapView, at: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTheMap))
        mapView.addGestureRecognizer(tapGesture)
        
        radiusPublisher
            .sink { [unowned self] _ in setCamera(to: mapView.centerCoordinate) }
            .store(in: &subscription)
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
                                        latitudinalMeters: radius,
                                        longitudinalMeters: radius)
        mapView.setRegion(region, animated: true)
    }
    
    func setCameraToCurrentLocation() {
        setCamera(to: currentLocation)
    }
    
    func zoomIn() {
        radius /= 2
        radiusPublisher.send(radius)
    }
    
    func zoomOut() {
        radius *= 2
        radiusPublisher.send(radius)
    }
    
    deinit {
        for item in subscription {
            item.cancel()
        }
        subscription.removeAll()
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
