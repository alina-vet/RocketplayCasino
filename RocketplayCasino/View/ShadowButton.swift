//
//  ShadowButton.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 12.09.2024.
//

import UIKit

class ShadowButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        updateShadow()
    }
    
    private func updateShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
    }
}
