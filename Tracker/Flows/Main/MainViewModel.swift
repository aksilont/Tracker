//
//  MainViewModel.swift
//  Tracker
//
//  Created by Aksilont on 05.04.2022.
//

import UIKit

final class MainViewModel: ObservableObject {
    
    @Published var showSecretView: Bool = false
    
    init() {
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
        showSecretView = true
    }
    
    @objc func appBecomesActive() {
        showSecretView = false
    }
}
