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
    
    private let selfieDelegate = SelfieDelegate()
    
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
        
        mainView.takeSelfie = { [weak self] in
            self?.takeSelfie()
        }
        
        mainView.showSelfie = { [weak self] in
            self?.showSelfie()
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
    
    private func takeSelfie() {
        selfieDelegate.onTakePicture = { [weak self] image in
            let selfieVC = SelfieViewController()
            selfieVC.image = image
            self?.rootController?.pushViewController(selfieVC, animated: true)
            
            FileManager.default.saveSelfie(image: image)
        }
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = selfieDelegate
        
        rootController?.present(imagePickerController, animated: true)
    }
    
    private func showSelfie() {
        if let image = FileManager.default.getSelfie() {
            let selfieVC = SelfieViewController()
            selfieVC.image = image
            rootController?.pushViewController(selfieVC, animated: true)
        }
    }
    
}
