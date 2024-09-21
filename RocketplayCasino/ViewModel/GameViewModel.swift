//
//  GameViewModel.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 14.09.2024.
//

import Foundation

class GameViewModel {
    
    private let defaults = UserDefaults.standard
    
    let maxBet = 3000
    let betStep = 50
    var currentBet: Int = 0
    
    let rouletteRewards = [
        RouletteModel(cellType: .jackpot, score: 20000),
        RouletteModel(cellType: .reward, score: 1000),
        RouletteModel(cellType: .bonus, score: 2500),
        RouletteModel(cellType: .reward, score: 3000),
        RouletteModel(cellType: .lose, score: 0),
        RouletteModel(cellType: .reward, score: 5000),
        RouletteModel(cellType: .reward, score: 8000),
        RouletteModel(cellType: .reward, score: 7000),
        RouletteModel(cellType: .jackpot, score: 20000),
        RouletteModel(cellType: .reward, score: 9000),
        RouletteModel(cellType: .bonus, score: 2500),
        RouletteModel(cellType: .reward, score: 7000),
        RouletteModel(cellType: .lose, score: 0),
        RouletteModel(cellType: .reward, score: 6000),
        RouletteModel(cellType: .reward, score: 4000),
        RouletteModel(cellType: .reward, score: 2000)
    ]
    
    var slotImageArray: [String] {
        return (0...6).map { "item_\($0)" }
    }
    
    var balance: Int {
        get {
            return defaults.integer(forKey: "currentBalance")
        }
        set {
            defaults.setValue(newValue, forKey: "currentBalance")
            defaults.synchronize()
        }
    }
    
    init() {
        if defaults.object(forKey: "currentBalance") == nil {
            defaults.setValue(20000, forKey: "currentBalance")
        }
    }
    
    func pauseMusic(_ isPause: Bool) {
        guard !AudioManager.shared.isSoundOff else { return }
        if isPause {
            AudioManager.shared.backgroundPlayer?.pause()
        } else {
            if AudioManager.shared.backgroundPlayer != nil {
                AudioManager.shared.backgroundPlayer?.play()
            } else {
                AudioManager.shared.playBackgroundMusic()
            }
        }
    }
}
