//
//  SelfieViewController.swift
//  Tracker
//
//  Created by Aksilont on 01.06.2022.
//

import UIKit

class SelfieViewController: UIViewController {
    
    var image: UIImage?
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        imageView.frame = view.bounds
        imageView.image = image
        view.addSubview(imageView)
    }
    
}
