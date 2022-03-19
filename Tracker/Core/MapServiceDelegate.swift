//
//  MapServiceDelegate.swift
//  Tracker
//
//  Created by Aksilont on 19.03.2022.
//

import Foundation
import CoreLocation
import Combine

protocol MapServiceDelegate {
    var publisher: PassthroughSubject<String, Never> { get set }
    
    func configureMap()
    func setCurrentLocation(_ location: CLLocationCoordinate2D)
    func addMarkerkToCurrentLocatin()
    func setCameraToCurrentLocation()
}
