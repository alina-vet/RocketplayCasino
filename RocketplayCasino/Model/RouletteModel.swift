//
//  RouletteModel.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 15.09.2024.
//

import Foundation

struct RouletteModel {
    var cellType: RouletteRewardType
    var score: Int
}

enum RouletteRewardType {
    case bonus
    case jackpot
    case reward
    case lose
}
