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
    private var updatingCount: Int = 0
    private var gap: CGFloat = 10
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
        updatingCount = 0
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        updatingCount += 1
        guard updatingCount == 2 else { return }
        setupBorders()
        setupBrickNodes()
        setupBarriers()
        setupBallNode()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard isGameStarted && !isGameOver else { return }
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch collision {
        case (PhysicsCategory.ball | PhysicsCategory.barrier):
            if !AudioManager.shared.isSoundOff {
                self.run(SKAction.playSoundFileNamed("hit", waitForCompletion: false))
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
        enumerateChildNodes(withName: "barrier") { node, _ in
            node.removeFromParent()
        }
        
        let totalRows = 7
        let maxBarriersInRow = 9
        let barrierSize = frame.width * (15 / 322)
        gap = (frame.width - (barrierSize * 9)) / 8
        
        var initialY = brickMaxY + (barrierSize * 2)
        
        for row in 0..<totalRows {
            let nodesInRow = maxBarriersInRow - row
            let totalWidth = CGFloat(nodesInRow) * barrierSize + CGFloat(nodesInRow - 1) * gap
            var initialX = (frame.width - totalWidth) / 2 + barrierSize / 2
            
            for _ in 0..<nodesInRow {
                let barrierNode = BarrierNode(radius: barrierSize)
                barrierNode.position = CGPoint(x: initialX, y: initialY)
                addChild(barrierNode)
                initialX += barrierSize + gap
            }
            initialY += barrierSize + gap
        }
    }
    
    private func setupBrickNodes() {
        enumerateChildNodes(withName: "brick") { node, _ in
            node.removeFromParent()
        }
        
        let numbersOfBricks = [5, 2, 1, 0, 1, 2, 5]
        let brickWidth = frame.width * (36 / 322)
        let gap = (frame.width - 14 - (brickWidth * CGFloat(numbersOfBricks.count))) / CGFloat(numbersOfBricks.count - 1)
        
        brickMaxY = frame.minY + brickWidth / 1.5
        var initialX = frame.minX + 8 + brickWidth / 2
        
        
        for number in 0..<numbersOfBricks.count {
            let node = BrickNode(number: numbersOfBricks[number],
                                 brickSize: CGSize(width: brickWidth,
                                                   height: brickWidth * (21 / 36)))
            node.position = CGPoint(x: initialX, y: brickMaxY)
            addChild(node)
            initialX += brickWidth + gap
        }
    }
    
    private func setupBallNode() {
        enumerateChildNodes(withName: "ball") { node, _ in
            node.removeFromParent()
        }
        print(frame)
        ballNode = BallNode(radius: gap)
        ballNode.position = CGPoint(x: frame.midX - ([-3, -2, -1, 1, 2, 3].randomElement() ?? 2),
                                    y: frame.maxY - ballNode.frame.height * (frame.width < 300 ? 3 : 1))
        addChild(ballNode)
    }
}
