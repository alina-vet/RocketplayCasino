//
//  BarrierNode.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 17.09.2024.
//

import SpriteKit

class BarrierNode: SKSpriteNode {
    
    var radius: CGFloat
    
    init(radius: CGFloat) {
        self.radius = radius
        
        let nodeSize = CGSize(width: radius, height: radius)
        
        let texture = SKTexture(imageNamed: "barrier")
        super.init(texture: texture, color: .clear, size: nodeSize)
        
        let physicsBody = SKPhysicsBody(circleOfRadius: radius * 0.4)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = PhysicsCategory.barrier
        self.physicsBody = physicsBody
        
        self.zPosition = 1
        self.name = "barrier"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
