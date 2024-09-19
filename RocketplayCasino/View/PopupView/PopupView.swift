//
//  PopupView.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 14.09.2024.
//

import UIKit

protocol PopupViewDelegate: AnyObject {
    func didButtonTouchDown()
}

class PopupView: UIView {

    @IBOutlet weak var popupView: UIView!
    
    weak var delegate: PopupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let xibView = Bundle.main.loadNibNamed("PopupView",
                                               owner: self,
                                               options: nil)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
        
        popupView.layer.cornerRadius = 18
        popupView.layer.borderColor = UIColor.white.cgColor
        popupView.layer.borderWidth = 1
    }
    
    func showPopupView(for gameType: GameType, at vc: UIViewController) {
        guard let superview = vc.view else { return }
        popupView.backgroundColor = gameType.popupColor.withAlphaComponent(0.85)
        superview.addSubview(self)
        popupView.animationIn(backView: self)
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        delegate?.didButtonTouchDown()
        popupView.animationOut(backView: self) { [weak self] in
            AudioManager.shared.stopSounds()
            self?.removeFromSuperview()
        }
    }
}
