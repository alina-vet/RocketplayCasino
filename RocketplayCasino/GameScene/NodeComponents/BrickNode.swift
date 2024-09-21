//
//  BrickNode.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 17.09.2024.
//

import SpriteKit

class BrickNode: SKSpriteNode {
    
    var number: Int
    var brickSize: CGSize
    
    init(number: Int, brickSize: CGSize) {
        self.number = number
        self.brickSize = brickSize
        
        let texture = SKTexture(imageNamed: "brick_\(number)")
        super.init(texture: texture, color: .clear, size: brickSize)
        
        let physicsBody = SKPhysicsBody(texture: texture, size: brickSize)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = PhysicsCategory.brick
        self.physicsBody = physicsBody
        
        self.userData = NSMutableDictionary()
        self.userData?.setValue(number == 0 ? 0.5 : CGFloat(number), forKey: "reward")
        
        self.zPosition = 3
        self.name = "brick"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
