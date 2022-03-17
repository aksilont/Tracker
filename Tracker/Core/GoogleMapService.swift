//
//  GoogleMapService.swift
//  Tracker
//
//  Created by Aksilont on 17.03.2022.
//

import Foundation
import GoogleMaps
import Combine

protocol MapServiceDelegate {
}

class GoogleMapService: NSObject, MapServiceDelegate {
    var marker: GMSMarker?
    var manualMarker: GMSMarker?
    var publisherAddress: AnyPublisher<String, Never>?
    var address: String = ""
    var publisher = PassthroughSubject<String, Never>()
    let geocoder = CLGeocoder()
    
    func addMarker(to location: CLLocationCoordinate2D, on mapView: GMSMapView) {
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
