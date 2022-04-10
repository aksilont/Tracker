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
    private var subscriptions: Set<AnyCancellable> = []
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    // MARK: - Lify cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapService()
        setupSecretView()
    }
    
    // MARK: - Secret View (Blur Effect)
    
    private func setupSecretView() {
        visualEffectView.frame = view.frame
        visualEffectView.frame.origin.y -= self.visualEffectView.frame.size.height
        view.addSubview(visualEffectView)
        
        addObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appBecomesActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    @objc func appMovedToBackground() {
        UIView.animate(withDuration: 1.0) { [unowned self] in
            visualEffectView.frame.origin.y += visualEffectView.frame.size.height
        }
    }
    
    @objc func appBecomesActive() {
        UIView.animate(withDuration: 1.0) { [unowned self] in
            visualEffectView.frame.origin.y -= visualEffectView.frame.size.height
        }
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
        for item in subscriptions {
            item.cancel()
        }
    }
    
}
