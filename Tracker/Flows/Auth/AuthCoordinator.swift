//
//  AuthCoordinator.swift
//  Tracker
//
//  Created by Aksilont on 31.03.2022.
//

import UIKit
import SwiftUI

class AuthCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showLoginModule()
    }
    
    private func showLoginModule() {
        var loginView = LoginView()
        
        loginView.onRecovery = { [weak self] in
            self?.showRecoveryModule()
        }
        
        loginView.onSignUp = { [weak self] in
            self?.showSignUpModule()
        }
        
        loginView.onLogin = { [weak self] in
            self?.onFinishFlow?()
        }
        
        let controller = UIHostingController(rootView: loginView)
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showRecoveryModule() {
        let controller = UIHostingController(rootView: RecoveryView())
        rootController?.pushViewController(controller, animated: true)
    }
    
    private func showSignUpModule() {
        let controller = UIHostingController(rootView: SignUpView())
        rootController?.pushViewController(controller, animated: true)
    }
    
}
