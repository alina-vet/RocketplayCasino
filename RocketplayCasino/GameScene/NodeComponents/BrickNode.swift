//
//  BrickNode.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 17.09.2024.
//

import SpriteKit

class BrickNode: SKSpriteNode {
    
    var number: Int
    
    init(number: Int) {
        self.number = number
        
        let nodeSize = CGSize(width: UIScreen.main.bounds.height * (36 / 390),
                              height: UIScreen.main.bounds.height * (21 / 390))
        
        let texture = SKTexture(imageNamed: "brick_\(number)")
        super.init(texture: texture, color: .clear, size: nodeSize)
        
        let physicsBody = SKPhysicsBody(texture: texture, size: nodeSize)
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
