//
//  GameScene.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 12.09.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var vc: GameViewController?
    
    private var ballNode: BallNode!
    private var brickMaxY: CGFloat = 0
    var currentBet = 0 {
        didSet { vc?.currentBet = currentBet }
    }
    var isGameStarted: Bool = false {
        didSet {
            guard let ballNode = ballNode else { return }
            ballNode.physicsBody?.isDynamic = isGameStarted
        }
    }
    var isGameOver: Bool = false {
        didSet { vc?.isGameOver = isGameOver }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -3.6)
        physicsWorld.contactDelegate = self
        
        setupBorders()
        setupBrickNodes()
        setupBarriers()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard isGameStarted && !isGameOver else { return }
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch collision {
        case (PhysicsCategory.ball | PhysicsCategory.barrier):
            if !AudioManager.shared.isSoundOff {
                self.run(SKAction.playSoundFileNamed("hit", waitForCompletion: true))
            }
        case (PhysicsCategory.ball | PhysicsCategory.brick):
            guard let brickNode = (contact.bodyA.categoryBitMask == PhysicsCategory.brick ? contact.bodyA.node : contact.bodyB.node) as? BrickNode,
                  let ballNode = (contact.bodyA.categoryBitMask == PhysicsCategory.ball ? contact.bodyA.node : contact.bodyB.node) as? BallNode
            else {
                return
            }
            ballNode.removeAllActions()
            ballNode.removeFromParent()
            self.ballNode = nil
            if let reward = brickNode.userData?.value(forKey: "reward") as? CGFloat {
                let newValue = CGFloat(currentBet) * reward
                currentBet += Int(newValue.rounded())
            }
            isGameOver = true
        default:
            break
        }
    }
    
    func restartGame() {
        isGameOver = false
        currentBet = 0
        setupBallNode()
    }
    
    private func setupBorders() {
        let border = SKPhysicsBody(edgeLoopFrom: frame)
        border.friction = 0
        self.physicsBody = border
    }
    
    private func setupBarriers() {
        let totalRows = 7
        let maxBarriersInRow = 9
        let gap = frame.height * (20 / 390)
        let barrierSize = (frame.width - (gap * CGFloat(maxBarriersInRow - 1))) / CGFloat(maxBarriersInRow)
        
        var initialY = brickMaxY + (barrierSize * 1.5)
        
        for row in 0..<totalRows {
            let nodesInRow = maxBarriersInRow - row
            let totalWidth = CGFloat(nodesInRow) * barrierSize + CGFloat(nodesInRow - 1) * gap
            var initialX = (frame.width - totalWidth) / 2 + barrierSize / 2
            
            for _ in 0..<nodesInRow {
                let barrierNode = BarrierNode(radius: barrierSize / 1.5)
                barrierNode.position = CGPoint(x: initialX, y: initialY)
                addChild(barrierNode)
                initialX += barrierSize + gap
            }
            initialY += barrierSize + gap
        }
    }
    
    private func setupBrickNodes() {
        let numbersOfBricks = [5, 2, 1, 0, 1, 2, 5]
        let brickWidth = frame.height * (36 / 390)
        let gap = (frame.width - 16 - (brickWidth * CGFloat(numbersOfBricks.count))) / CGFloat(numbersOfBricks.count - 1)
        
        brickMaxY = frame.minY + brickWidth / 1.5
        var initialX = frame.minX + 8 + brickWidth / 2
        
        
        for number in 0..<numbersOfBricks.count {
            let node = BrickNode(number: numbersOfBricks[number])
            node.position = CGPoint(x: initialX, y: brickMaxY)
            addChild(node)
            initialX += brickWidth + gap
        }
    }
    
    private func setupBallNode() {
        ballNode = BallNode()
        ballNode.position = CGPoint(x: frame.midX - ([-3, -2, -1, 1, 2, 3].randomElement() ?? 2),
                                    y: frame.maxY - ballNode.frame.height)
        addChild(ballNode)
    }
}
