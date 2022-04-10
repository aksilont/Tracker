//
//  MapViewController.swift
//  Tracker
//
//  Created by Aksilont on 13.03.2022.
//

import UIKit
import Combine

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - Properties
    
    var mapType: MapType!
    private var mapService: MapServiceProtocol!
    private var locationManager: LocationManager!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    var someProp: String = ""
    
    // MARK: - Lify cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapService()
        configureLocationManager()
    }
    
    // MARK: - Services
    
    func configureMapService() {
        switch mapType {
        case .google:
            mapService = GoogleMapService(contentView: contentView)
        case .apple:
            mapService = AppleMapService(contentView: contentView)
        case .none:
            mapService = AppleMapService(contentView: contentView)
        }
        mapService.contentView = contentView
        mapService.configureMap()
        
        mapService.addressPublisher
            .sink { [unowned self] in addressLabel.text = $0 }
            .store(in: &subscriptions)
    }
    
    func configureLocationManager() {
        locationManager = LocationManager()
        locationManager.currentLocationPublisher
            .sink { [unowned self] in mapService.setCurrentLocation($0) }
            .store(in: &subscriptions)
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
    
    @IBAction func nextRoute(_ sender: UIButton) {
        mapService.nextRoute(reverse: false)
    }
    
    @IBAction func previousRoute(_ sender: UIButton) {
        mapService.nextRoute(reverse: true)
    }
    
    @IBAction func closeMap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Deinit
    
    deinit {
        locationManager.stopUpdatingLocation()
        for item in subscriptions {
            item.cancel()
        }
    }
    
}
