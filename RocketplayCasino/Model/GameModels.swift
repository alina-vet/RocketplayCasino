//
//  GameModels.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 14.09.2024.
//

import UIKit

enum GameResult: String {
    case lose
    case win
}

enum GameType {
    case slot
    case roulette
    case plinko
    
    var bgName: String {
        switch self {
        case .slot:
            "slots bg"
        case .roulette:
            "roulette bg"
        case .plinko:
            ""
        }
    }
    
    var popupColor: UIColor {
        switch self {
        case .slot:
            "#1A056F".hexStringToUIColor()
        case .roulette:
            "#4D38A5".hexStringToUIColor()
        case .plinko:
            "#690296".hexStringToUIColor()
        }
    }
}
