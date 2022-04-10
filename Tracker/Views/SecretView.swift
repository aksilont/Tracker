//
//  SecretView.swift
//  Tracker
//
//  Created by Aksilont on 05.04.2022.
//

import UIKit

class SecretView: UIView {

     private lazy var textLabel: UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.textAlignment = .center
         label.text = "Tracker"
         label.textColor = .black
         label.font = UIFont.boldSystemFont(ofSize: 40.0)
         return label
     }()

     override init(frame: CGRect) {
         super.init(frame: frame)
         configureUI()
     }

     required init?(coder: NSCoder) {
         super.init(coder: coder)
         configureUI()
     }

     private func configureUI() {
         backgroundColor = .systemTeal
         addSubview(textLabel)

         NSLayoutConstraint.activate([
             textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
             textLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
         ])
     }
 }
