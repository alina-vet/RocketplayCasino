//
//  PhysicsCategory.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 17.09.2024.
//

import Foundation

struct PhysicsCategory {
    static let ball: UInt32 = 0x1 << 0
    static let brick: UInt32 = 0x1 << 1
    static let barrier: UInt32 = 0x1 << 2
}
