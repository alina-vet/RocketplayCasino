//
//  CustomButton.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 14.09.2024.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let titleLabel = self.titleLabel?.layer else { return }
        titleLabel.shadowOffset = CGSize(width: -1, height: 1)
        titleLabel.shadowColor = "#F2FA99".hexStringToUIColor().cgColor
        titleLabel.shadowOpacity = 1
        titleLabel.shadowRadius = 1
    }
}
