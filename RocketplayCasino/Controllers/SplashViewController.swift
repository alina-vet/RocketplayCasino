//
//  SplashViewController.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 12.09.2024.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet var dotViews: [UIView]!
    
    let animationStartTime = Date()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRepeatingDotsAnimation()
    }
    
    private func startRepeatingDotsAnimation() {
        let animationStartTime = Date()
        
        func repeatAnimation() {
            startDotsAnimation {
                if Date().timeIntervalSince(animationStartTime) < 3.0 {
                    repeatAnimation()
                } else {
                    self.changeRootVC()
                }
            }
        }
        
        repeatAnimation()
    }
    
    private func startDotsAnimation(completion: @escaping () -> Void) {
        for (index, dot) in dotViews.enumerated() {
            UIView.animate(withDuration: 0.3, delay: 0.3 * Double(index)) {
                dot.transform = CGAffineTransform(translationX: 0, y: -2)
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    dot.transform = CGAffineTransform(translationX: 0, y: 2)
                } completion: { _ in
                    if index == self.dotViews.count - 1 {
                        completion()
                    }
                }
            }
        }
    }

    private func changeRootVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        if let window = UIApplication.shared.windows.first {
            window.fadeTransition()
            window.rootViewController = navigationController
        }
    }
}
