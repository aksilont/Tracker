//
//  AppleMapService.swift
//  Tracker
//
//  Created by Aksilont on 20.03.2022.
//

import Combine
import CoreLocation
import MapKit

class AppleMapService: NSObject, MapServiceProtocol {
    
    // MARK: - Properties
    
    private let geocoder = CLGeocoder()
    private var marker: MKPointAnnotation = MKPointAnnotation()
    private var manualMarker: MKPointAnnotation = MKPointAnnotation()
    
    private let coordinateMoscow = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private var currentLocation = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private var radius = 500.0
    
    var contentView: UIView
    var mapView = MKMapView()
    var addressPublisher = PassthroughSubject<String, Never>()
    private var subscription: Set<AnyCancellable> = []
    
    private var route: [CLLocationCoordinate2D] = []
    private var isTracking = false
    
    private let dataRepository = DataRepository()
    private var routes: [Route] = []
    private var currentRouteIndex = 0
    
    // MARK: - Init
    
    required init(contentView: UIView) {
        self.contentView = contentView
    }
    
    // MARK: - Configure
    
    func configureMap() {
        let region = MKCoordinateRegion(center: coordinateMoscow, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.delegate = self
        mapView.frame = contentView.frame
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        contentView.insertSubview(mapView, at: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTheMap))
        mapView.addGestureRecognizer(tapGesture)
        
        fetchRoutes()
    }
    
    @objc func tapOnTheMap(_ sender: UIGestureRecognizer) {
        let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
        manualMarker.coordinate = coordinate
        mapView.removeAnnotation(manualMarker)
        mapView.addAnnotation(manualMarker)
    }
    
    // MARK: - Routes
    
    func fetchRoutes() {
        dataRepository.fetchRoutes { [unowned self] in routes = $0 }
    }
    
    func showRoute(_ route: Route) {
        guard let result = route.coordinates else { return }
        let coordinates = result.map { item -> CLLocationCoordinate2D in
            let location = item as! Coordinate
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        
        setCameraToRoute(with: coordinates)
    }
    
    func nextRoute(reverse: Bool) {
        isTracking = false
        route = []
        removeAllOverlays()
        
        let routesCount = routes.count
        
        guard routesCount > 0 else { return }
        
        showRoute(routes[currentRouteIndex])
        if reverse {
            currentRouteIndex = currentRouteIndex == 0 ? routesCount - 1 : currentRouteIndex - 1
        } else {
            currentRouteIndex = currentRouteIndex == routesCount - 1 ? 0 : currentRouteIndex + 1
        }
    }
    
    // MARK: - Current location
    
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
    
    // MARK: - Annotation
    
    func addMarker(to location: CLLocationCoordinate2D) {
        marker.coordinate = location
        mapView.removeAnnotation(marker)
        mapView.addAnnotation(marker)
    }
    
    func addMarkerkToCurrentLocatin() {
        addMarker(to: currentLocation)
        route.append(currentLocation)
    }
    
    // MARK: - Camera
    
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
    
    func setCameraToRoute(with coordinates: [CLLocationCoordinate2D]) {
        let routePolyLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(routePolyLine)
        
        let mapRect = routePolyLine.boundingMapRect.insetBy(dx: -500, dy: -500)
        mapView.setVisibleMapRect(mapRect, animated: true)
    }
    
    func removeAllOverlays() {
        mapView.removeOverlays(mapView.overlays)
    }
    
    // MARK: - Zoom
    
    func zoomIn() {
        radius = radius / 2 <= 100 ? 100 : radius / 2
        setCamera(to: mapView.centerCoordinate)
    }
    
    func zoomOut() {
        radius *= 2
        setCamera(to: mapView.centerCoordinate)
    }
    
    // MARK: - Route
    
    func startStopRecordRoute() {
        isTracking ? stopRecordRoute() : startRecordRoute()
    }
    
    private func startRecordRoute() {
        route = []
        removeAllOverlays()
        isTracking = true
    }
    
    private func stopRecordRoute() {
        let newRoute = dataRepository.createNewRoute()
        for item in route {
            dataRepository.add(coordinate: item, to: newRoute)
        }
        currentRouteIndex = routes.count
        
        isTracking = false
        route = []
        removeAllOverlays()
        
        fetchRoutes()
    }
    
    // MARK: - Deinit
    
    deinit {
        for item in subscription {
            item.cancel()
        }
        subscription.removeAll()
    }
}

// MARK: - MKMapViewDelegate

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
