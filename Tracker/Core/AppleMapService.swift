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
    
    private var route = [CLLocationCoordinate2D]()
    private var isTracking = false
    
    required init(contentView: UIView) {
        self.contentView = contentView
    }
    
    func configureMap() {
        let region = MKCoordinateRegion(center: coordinateMoscow, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.delegate = self
        mapView.frame = contentView.frame
        mapView.showsUserLocation = true
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
        
        if isTracking {
            setCameraToCurrentLocation()
            route.append(currentLocation)
            
            removeAllOverlays()
            
            let routePolyLine = MKPolyline(coordinates: route, count: route.count)
            mapView.addOverlay(routePolyLine)
        }
    }
    
    func addMarker(to location: CLLocationCoordinate2D) {
        marker.coordinate = location
        mapView.removeAnnotation(marker)
        mapView.addAnnotation(marker)
    }
    
    func addMarkerkToCurrentLocatin() {
        addMarker(to: currentLocation)
        route.append(currentLocation)
    }
    
    func setCamera(to location: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 1) {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: self.radius,
                                            longitudinalMeters: self.radius)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func setCameraToCurrentLocation() {
        setCamera(to: currentLocation)
    }
    
    func zoomIn() {
        radius = radius / 2 <= 100 ? 100 : radius / 2
        radiusPublisher.send(radius)
    }
    
    func zoomOut() {
        radius *= 2
        radiusPublisher.send(radius)
    }
    
    func removeAllOverlays() {
        mapView.removeOverlays(mapView.overlays)
    }
    
    func startRecordRoute() {
        route = []
        removeAllOverlays()
        isTracking = true
    }
    
    func stopRecordRoute() {
        isTracking = false
        route = []
        removeAllOverlays()
    }
    
    // MARK: - Deinit
    
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
