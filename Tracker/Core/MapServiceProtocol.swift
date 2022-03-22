//
//  MapServiceProtocol.swift
//  Tracker
//
//  Created by Aksilont on 19.03.2022.
//

import UIKit
import CoreLocation
import Combine

protocol MapServiceProtocol {
    var contentView: UIView { get set }
    var publisher: PassthroughSubject<String, Never> { get set }
    
    init(contentView: UIView)
    
    func configureMap()
    func setCurrentLocation(_ location: CLLocationCoordinate2D)
    
    func addMarker(to location: CLLocationCoordinate2D)
    func addMarkerkToCurrentLocatin()
    
    func setCamera(to location: CLLocationCoordinate2D)
    func setCameraToCurrentLocation()
    
    func zoomIn()
    func zoomOut()
}
