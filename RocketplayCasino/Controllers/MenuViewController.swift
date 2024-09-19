//
//  MenuViewController.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 12.09.2024.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? QuizViewController else { return }
        switch segue.identifier {
        case "showSlotFromMenu":
            destination.gameType = .slot
        case "showRouletteFromMenu":
            destination.gameType = .roulette
        default: 
            break
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        navigationController?.view.fadeTransition()
    }
}
