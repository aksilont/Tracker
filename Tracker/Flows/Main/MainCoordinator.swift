//
//  MainCoordinator.swift
//  Tracker
//
//  Created by Aksilont on 31.03.2022.
//

import UIKit
import SwiftUI

class MainCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMainModule()
    }
    
    private func showMainModule() {
        var mainView = MainView()
        
        mainView.onMap = { [weak self] mapType in
            self?.showMapModule(mapType: mapType)
        }
        
        mainView.onLogout = { [weak self] in
            self?.onFinishFlow?()
        }
        
        let controller = UIHostingController(rootView: mainView)
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showMapModule(mapType: MapType) {
        let controller = UIStoryboard(name: "Map", bundle: nil)
            .instantiateViewController(MapViewController.self)
        controller.mapType = mapType
        controller.navigationItem.hidesBackButton = true
        rootController?.pushViewController(controller, animated: true)
    }
}
