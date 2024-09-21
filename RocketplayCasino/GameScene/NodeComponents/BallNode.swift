//
//  BallNode.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 17.09.2024.
//

import SpriteKit

class BallNode: SKSpriteNode {
    
    var radius: CGFloat
    
    init(radius: CGFloat) {
        self.radius = radius
        
        let nodeSize = CGSize(width: radius, height: radius)
        
        let texture = SKTexture(imageNamed: "pink ball")
        super.init(texture: texture, color: .clear, size: nodeSize)
        
        let physicsBody = SKPhysicsBody(circleOfRadius: radius * 0.4)
        physicsBody.isDynamic = false
        physicsBody.restitution = 0.2
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
