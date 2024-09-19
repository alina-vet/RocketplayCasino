//
//  WheelView.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 15.09.2024.
//

import UIKit

class WheelView: UIView {
    
    @IBOutlet weak var wheelImageView: UIImageView!
    
    private var currentRotationAngle: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let xibView = Bundle.main.loadNibNamed("WheelView",
                                               owner: self,
                                               options: nil)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    func speenWheel(gameViewModel: GameViewModel, completion: @escaping (() -> Void)) {
        let duration: CFTimeInterval = 3.0
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        let currentRotation = currentRotationAngle
        let fullRounds = 5.0 * CGFloat.pi * 2
        let randomIndex = Int.random(in: 0..<gameViewModel.rouletteRewards.count)
        let anglePerCell = CGFloat.pi * 2 / CGFloat(gameViewModel.rouletteRewards.count)
        let randomAngle = CGFloat(randomIndex) * anglePerCell
        let targetRotation = fullRounds + randomAngle
        
        rotation.fromValue = currentRotation
        rotation.toValue = currentRotation + targetRotation
        rotation.duration = duration
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        rotation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        wheelImageView.layer.add(rotation, forKey: "spinAnimation")
        AudioManager.shared.playSounds("spinning")
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.checkWheelAngle()
            AudioManager.shared.stopSounds()
            completion()
        }
    }
    
    func getStoppedIndex() -> Int {
        let degreesAngle = currentRotationAngle * 180 / .pi
        let degrees = currentRotationAngle > 0 ? abs(360.0 - degreesAngle) : abs(degreesAngle)
        return Int(degrees / (360 / 16))
    }
    
    private func checkWheelAngle() {
        if let presentationLayer = wheelImageView.layer.presentation(),
           let transform = presentationLayer.value(forKeyPath: "transform.rotation") as? CGFloat {
            currentRotationAngle = transform
        }
    }
}
