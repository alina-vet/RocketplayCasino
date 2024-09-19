//
//  GradientView.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 12.09.2024.
//

import UIKit

class GradientView: UIView {
    @IBInspectable var startColor: UIColor = .black { didSet { updateColors() }}
    @IBInspectable var middleColor: UIColor? { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = .white { didSet { updateColors() }}
    @IBInspectable var horizontalMode: Bool = false { didSet { updatePoints() }}
    @IBInspectable var isRadial: Bool = false { didSet { updateType() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func updatePoints() {
        if isRadial {
            gradientLayer.startPoint = .init(x: 0.5, y: 0.5)
            gradientLayer.endPoint = .init(x: 1.0, y: 1.0)
        } else {
            gradientLayer.startPoint = horizontalMode ? .init(x: 0, y: 0.5) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint = horizontalMode ? .init(x: 1, y: 0.5) : .init(x: 0.5, y: 1)
        }
    }
    
    func updateLocations() {
        gradientLayer.locations = [0, 1]
        if middleColor != nil {
            gradientLayer.locations?.insert(0.5, at: 1)
        }
    }
    
    func updateColors() {
        gradientLayer.colors = [startColor, endColor].map { $0.cgColor }
        if let middleColor = middleColor {
            gradientLayer.colors?.insert(middleColor, at: 1)
        }
    }
    
    func updateType() {
        gradientLayer.type = isRadial ? .radial : .axial
        updatePoints()
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
        updateType()
    }
}
