//
//  BallNode.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 17.09.2024.
//

import SpriteKit

class BallNode: SKSpriteNode {
    
    init() {
        
        let radius = UIScreen.main.bounds.height * (20 / 390)
        
        let nodeSize = CGSize(width: radius, height: radius)
        
        let texture = SKTexture(imageNamed: "pink ball")
        super.init(texture: texture, color: .clear, size: nodeSize)
        
        let physicsBody = SKPhysicsBody(circleOfRadius: radius * 0.4)
        physicsBody.isDynamic = false
        physicsBody.restitution = 0.6
        physicsBody.angularDamping = 0.2
        physicsBody.linearDamping = 0.1
        physicsBody.categoryBitMask = PhysicsCategory.ball
        physicsBody.contactTestBitMask = PhysicsCategory.brick | PhysicsCategory.barrier
        self.physicsBody = physicsBody
        
        self.zPosition = 2
        self.name = "ball"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
