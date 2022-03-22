//
//  RoundButton.swift
//  Tracker
//
//  Created by Aksilont on 22.03.2022.
//

import UIKit

class RoundButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = self.frame.width / 2
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = UIColor.white.withAlphaComponent(0.75)

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
    }
    
}

