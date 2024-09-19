//
//  SettingViewController.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 12.09.2024.
//

import UIKit
import LinkPresentation

class SettingViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var soundButton: UIButton!
    
    private var audioManager = AudioManager.shared
    private var shareUrl = ""
    
    var didTapCloseButton: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0.0
        stackView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        soundButton.isSelected = audioManager.isSoundOff
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stackView.animationIn(backView: self.view)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        stackView.animationOut(backView: self.view) { [weak self] in
            self?.dismiss(animated: false) { [weak self] in
                self?.didTapCloseButton?()
            }
        }
    }
    
    @IBAction func soundToggleAction(_ sender: UIButton) {
        audioManager.isSoundOff.toggle()
        soundButton.isSelected = audioManager.isSoundOff
    }
    
    @IBAction func privacyPolicyTapped(_ sender: UIButton) {
        openURL("https://www.google.com")
    }
    
    @IBAction func termsOfUseTapped(_ sender: UIButton) {
        openURL("https://www.google.com")
    }
    
    @IBAction func shareAppAction(_ sender: UIButton) {
        guard shareUrl != "" else { return }
        let textToShare = "Check out this amazing app!"
        let urlToShare = URL(string: shareUrl)
        
        var items: [Any] = [textToShare]
        if let url = urlToShare {
            items.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .print]
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
